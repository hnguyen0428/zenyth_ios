//
//  PinpostFormController.swift
//  Zenyth
//
//  Created by Hoang on 8/23/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class PinpostFormController: UIViewController, UITextViewDelegate,
                            UINavigationControllerDelegate,
                            UIPickerViewDelegate,
                            GMSAutocompleteViewControllerDelegate {
    
    weak var pinpostFormView: PinpostFormView!
    
    let privacyOptions = ["", "Only for yourself", "For you and your followers",
                          "Everyone"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        setupViews()
        
        pinpostFormView.usePressedLocationButton.addTarget(self,
                                                           action: #selector(fillLocation),
                                                           for: .touchUpInside)
        pinpostFormView.locationField.addTarget(self, action: #selector(autocomplete), for: .editingDidBegin)
        pinpostFormView.titleField.addTarget(self, action: #selector(fieldCheck), for: .editingChanged)
    }
    
    func setupViews() {
        view.backgroundColor = UIColor(r: 244, g: 244, b: 244)
        
        let heightNavbar = self.navigationController!.navigationBar.frame.height
        let y = heightNavbar
        let frame = CGRect(x: 0, y: y, width: view.frame.width,
                           height: view.frame.height - heightNavbar)
        let pinpostFormView = PinpostFormView(frame: frame)
        self.pinpostFormView = pinpostFormView
        pinpostFormView.descriptionField.delegate = self
        
        view.addSubview(pinpostFormView)
        setupPrivacyPicker()
    }
    
    func setupPrivacyPicker() {
        let picker = UIPickerView()
        picker.delegate = self
        pinpostFormView.privacyField.inputView = picker
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Give a description"
            textView.textColor = UIColor.lightGray
        }
        _ = fieldCheck()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done,
                                         target: self,
                                         action: #selector(transitionToImageGallery))
        self.navigationItem.rightBarButtonItem = nextButton
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Create a Pinpost"
        
        _ = fieldCheck()
    }
    
    func autocomplete(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let filter = GMSAutocompleteFilter()
        let nwCoord = CLLocationCoordinate2D(latitude: 41.738528, longitude: -124.365234)
        let seCoord = CLLocationCoordinate2D(latitude: 32.509762, longitude: -114.082031)
        let bounds = GMSCoordinateBounds(coordinate: nwCoord, coordinate: seCoord)
        filter.type = .establishment
        
        autocompleteController.autocompleteBounds = bounds
        autocompleteController.autocompleteFilter = filter
        
        autocompleteController.tableCellBackgroundColor = .white
        autocompleteController.tintColor = UIColor.black
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func fillLocation(_ sender: UIButton) {
        let address = PinpostForm.shared.location
        let line = address.lines?.first
        
        if let str = line {
            pinpostFormView.locationField.text = str
        }
        _ = fieldCheck()
    }
    
    func transitionToImageGallery(_ sender: UIBarButtonItem) {
        if fieldCheck() {
            // Save info before transition
            let pinpostForm = PinpostForm.shared
            if let title = pinpostFormView.titleField.text {
                pinpostForm.title = title
            }
            if let description = pinpostFormView.descriptionField.text {
                pinpostForm.description = description
            }
            
            let controller = ImageGalleryController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func fieldCheck() -> Bool {
        guard
            let title = pinpostFormView.titleField.text, !title.isEmpty,
            let description = pinpostFormView.descriptionField.text, !description.isEmpty,
            let location = pinpostFormView.locationField.text, !location.isEmpty,
            let privacy = pinpostFormView.privacyField.text, !privacy.isEmpty
            else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                return false
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        return true
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is FeedController {
            PinpostForm.shared.clearInfo()
        }
    }
    
    /**
     Return the number of components in picker view. Conforming to the
     UIPickerViewDelegate protocol
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
     Return the number of options in the picker view. Conforming to the
     UIPickerViewDelegate protocol
     */
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return privacyOptions.count
    }
    
    /**
     Return the information to display for each row in the picker view.
     Conforming to the UIPickerViewDelegate protocol
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return privacyOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let privacy = privacyOptions[row]
        switch row {
        case 1:
            PinpostForm.shared.privacy = "self"
        case 2:
            PinpostForm.shared.privacy = "followers"
        case 3:
            PinpostForm.shared.privacy = "public"
        default:
            break
        }
        pinpostFormView.privacyField.text = privacy
        _ = fieldCheck()
    }
    
    // Handle the user's selection.
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        pinpostFormView.locationField.text = place.name
        PinpostForm.shared.coordinate = place.coordinate
        PinpostForm.shared.usePressedCoordinate = false
        
        dismiss(animated: true, completion:
            {
                _ = self.fieldCheck()
        })
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    public func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    public func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    deinit {
        print("Deinitializing")
    }
}
