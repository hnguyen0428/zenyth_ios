//
//  APIClient.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIClient {
    
    static let sharedClient = APIClient.init()

    // Prevent instantiation
    private init() {}
    
    var headers: HTTPHeaders = HTTPHeaders.init()
    
    func executeJSON(route: APIRoute,
                     parameters: Parameters = Parameters.init(),
                     onSuccess: JSONCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?) {
        let urlString = route.0
        let method = route.1
        
        Alamofire.request(urlString, method: method, parameters: parameters,
                          headers: self.headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    onSuccess?(json)
                }
                else {
                    print(json)
                    onFailure?(json)
                }
                
            case .failure(let error):
                debugPrint(response)
                print(error)
                onRequestError?(error as NSError)
            }
        }
    }
    
    func executeUpload(route: APIRoute,
                       data: Data,
                       fileKey: String,
                       onSuccess: JSONCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?) {
        let urlString = route.0
        let method = route.1
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: fileKey)
        }, to: urlString, method: method, headers: self.headers,
              encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            if json["success"].boolValue {
                                onSuccess?(json)
                            }
                            else {
                                print(json)
                                debugPrint(response)
                                onFailure?(json)
                            }
                        case .failure(let error):
                            print("RESPONSE JSON ERROR: \(error)")
                            onRequestError?(error as NSError)
                        }
                    }
                case .failure(let encodingError):
                    print("ENCODING ERROR: \(encodingError)")
                    onRequestError?(encodingError as NSError)
                }
        })
    }
    
    func executeDownload(route: APIRoute,
                         onSuccess: DataCallback?,
                         onRequestError: ErrorCallback?) {
        let urlString = route.0
        let method = route.1
        
        Alamofire.download(urlString,
                           method: method,
                           headers: self.headers).responseData
            { response in
                switch response.result {
                case .success(let data):
                    onSuccess?(Data(data))
                case .failure(let error):
                    print("DOWNLOAD ERROR: \(error)")
                    onRequestError?(error as NSError)
                }
        }
    }
    
    func setAuthorization() {
        let apiToken: String =
            UserDefaults.standard.object(forKey: "api_token") as! String
        self.headers.updateValue("Authorization",
                            forKey: "bearer \(apiToken)")
    }
    
    func updateHeaders(value: String, forKey key: String) {
        self.headers.updateValue(value, forKey: key)
    }
}
