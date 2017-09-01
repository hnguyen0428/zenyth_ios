//
//  EditProfileController.swift
//  Zenyth
//
//  Created by Hoang on 8/19/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import Foundation
import Photos

class EditProfileController: HomeController, UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate {
    
    var navbar: EditProfileToolbar?
    var scrollView: UIScrollView?
    var user: User?
    var profileImageView: UIImageView?
    var profileImage: UIImage?
    var profileEditView: ProfileEditView?
    
    let galleryPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navbar?.cancelButton?.addTarget(self, action: #selector(popBackToProfile), for: .touchUpInside)
        navbar?.saveButton?.addTarget(self, action: #selector(updateProfileHandler), for: .touchUpInside)
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView?.isUserInteractionEnabled = true
        profileImageView?.addGestureRecognizer(tapGesture)
    }
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = UIColor.white
        
        let navbarWidth = view.frame.width
        let navbarHeight = view.frame.height * 0.09
        let navbarFrame = CGRect(x: 0, y: 0, width: navbarWidth, height: navbarHeight)
        navbar = EditProfileToolbar(frame: navbarFrame)
        view.addSubview(navbar!)
        
        let scrollViewWidth: CGFloat = view.frame.width
        let scrollViewHeight: CGFloat = view.frame.height - navbarFrame.height
        let scrollViewFrame = CGRect(x: 0, y: navbarFrame.height,
                                     width: scrollViewWidth, height: scrollViewHeight)
        scrollView = UIScrollView(frame: scrollViewFrame)
        scrollView?.contentSize.height = view.frame.height
        scrollView?.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        view.insertSubview(scrollView!, at: 0)
        
        self.setupProfileImageView()
        self.setupProfileEditView()
        self.setupDatePicker()
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupProfileImageView() {
        let imageWidth = view.frame.width * 0.20
        let imageHeight = imageWidth
        
        let imageX: CGFloat = view.center.x - imageWidth/2
        let imageY: CGFloat = 20.0
        let imageFrame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        
        let container = UIView(frame: imageFrame)
        container.clipsToBounds = false
        container.layer.masksToBounds = false
        container.layer.shadowPath = UIBezierPath(roundedRect: container.bounds,
                                                  cornerRadius: imageFrame.height/2).cgPath
        container.layer.shadowColor = UIColor.lightGray.cgColor
        container.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        container.layer.shadowRadius = 2.0
        container.layer.shadowOpacity = 0.5
        
        let image = UIImageView(frame: container.bounds)
        image.layer.cornerRadius = imageFrame.height/2
        image.clipsToBounds = true
        image.backgroundColor = UIColor.clear
        
        profileImageView = image
        container.addSubview(profileImageView!)
        
        // If the profile image has not been rendered, render it
        if let image = profileImage {
            profileImageView?.image = image
        } else {
            profileImageView?.imageFromUrl(withUrl: (user?.profilePicture?.getURL(size: "medium"))!)
        }
        scrollView?.addSubview(container)

    }
    
    func setupProfileEditView() {
        let verticalOffset: CGFloat = 30.0
        
        let x = view.frame.origin.x
        let imageContainer = profileImageView!.superview
        let bottomOfProfilePic = imageContainer!.frame.origin.y + imageContainer!.frame.height
        let y = bottomOfProfilePic + verticalOffset
        
        let height = view.frame.height * 0.28
        let frame = CGRect(x: x, y: y, width: view.frame.width, height: height)
        
        profileEditView = ProfileEditView(frame: frame)
        scrollView?.addSubview(profileEditView!)
    }
    
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        profileEditView!.birthdayField!.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(changeDOBValue),
                             for: .valueChanged)
    }
    
    func changeDOBValue(_ picker: UIDatePicker) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMMM dd, yyyy"
        let date = dateFormat.string(from: picker.date)
        profileEditView?.setBirthday(date)
    }
    
    func updateProfileHandler() {
        let firstName = profileEditView?.firstName()
        let lastName = profileEditView?.lastName()
        let gender = profileEditView!.gender().lowercased()
        
        let dateString = profileEditView!.birthday()
        
        // Format birthday
        var birthday: String?
        if dateString != "" {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MMMM dd, yyyy"
            let date = dateFormat.date(from: dateString)
            dateFormat.dateFormat = "yyyy-MM-dd"
            birthday = dateFormat.string(from: date!)
        }
        
        let biography = profileEditView!.biography()
        
        UserManager().updateProfile(firstName: firstName, lastName: lastName,
                                    gender: gender, birthday: birthday,
                                    biography: biography,
                                    onSuccess:
            { user in
                var user = user
                user.numberOfPinposts = self.user!.numberOfPinposts
                user.pinposts = self.user!.pinposts
                user.likes = self.user!.likes
                self.user = user
                self.transitionToProfile()
        })
    }
    
    func imageTapped(_ tapGesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Change Your Profile Picture",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose From Your Photo Library",
                                      style: .default, handler:
            { (action) in
                self.galleryPicker.sourceType = .photoLibrary
                self.galleryPicker.delegate = self
                self.galleryPicker.allowsEditing = true
                self.present(self.galleryPicker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let data = UIImageJPEGRepresentation(image, 0.5)
            if let imageData = data {
                // Update profile picture
                self.uploadProfilePicture(data: imageData, handler:
                    { user in
                        // Dismiss photo library and go back to profile
                        self.dismiss(animated: true, completion:
                            { action in
                                var user = user
                                user.numberOfPinposts = self.user!.numberOfPinposts
                                user.pinposts = self.user!.pinposts
                                user.likes = self.user!.likes
                                self.user = user
                                self.profileImage = image
                                self.transitionToProfile(renderImage: true)
                        })
                }, picker: picker)
            }
        }
    }
    
    func uploadProfilePicture(data: Data, handler: UserCallback? = nil, picker: UIImagePickerController) {
        let indicator = picker.requestLoading(view: picker.view)
        UserManager().updateProfilePicture(imageData: data,
                                           onSuccess:
            { user in
                picker.requestDoneLoading(view: picker.view, indicator: indicator)
                handler?(user)
        }, onFailure:
            { json in
                picker.requestDoneLoading(view: picker.view, indicator: indicator)
                self.displayAlert(view: picker, title: "Image Failed To Upload",
                                  message: "Request Error")
        }, onRequestError:
            { error in
                picker.requestDoneLoading(view: picker.view, indicator: indicator)
                self.displayAlert(view: picker, title: "Image Failed To Upload",
                                  message: "Request Error")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let firstName = user?.firstName {
            profileEditView?.setFirstName(firstName)
        }
        if let lastName = user?.lastName {
            profileEditView?.setLastName(lastName)
        }
        
        if var gender = user?.gender {
            gender.capitalizeFirstLetter()
            profileEditView?.setGender(gender)
        }
        
        if let dateString = user!.birthday {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let date = dateFormat.date(from: dateString)
            dateFormat.dateFormat = "MMMM dd, yyyy"
            let birthday = dateFormat.string(from: date!)
            profileEditView?.setBirthday(birthday)
        }
        
        if let biography = user?.biography {
            profileEditView?.setBiography(biography)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func transitionToProfile(renderImage: Bool = false) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewController(animated: true)
        let controller = self.navigationController?.topViewController as! ProfileController
        
        controller.user = self.user
        
        // Render the updated user information
        controller.renderView()
        
        if renderImage {
            controller.profileView?.profilePicture?.image = self.profileImage
        }
    }
    
    func popBackToProfile() {
        self.navigationController?.popViewController(animated: true)
    }
}
