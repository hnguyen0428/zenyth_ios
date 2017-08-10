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
    
    var headers: HTTPHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    
    func executeJSON(route: APIRoute,
                     parameters: Parameters = Parameters.init(),
                     onSuccess: JSONCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?) {
        let urlString = route.0
        let method = route.1
        
        Alamofire.request(urlString, method: method, parameters: parameters,
                          headers: self.headers).responseJSON
            {
                response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["success"].boolValue {
                        onSuccess?(json)
                    }
                    else {
                        onFailure?(json)
                    }
                    
                case .failure(let error):
                    debugPrint(response)
                    print("Error: \(error)")
                    print("HTTPHeaders: \(self.headers)")
                    print("HTTPMethod: \(method)")
                    onRequestError?(error as NSError)
                }
                self.resetHeaders()
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
            multipartFormData.append(data, withName: fileKey,
                                     fileName: "file.jpg",
                                     mimeType: "image/jpg")
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
                self.resetHeaders()
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
                self.resetHeaders()
        }
        
    }
    
    func setAuthorization(token: String? = nil) {
        if token == nil {
            let apiToken: String =
                UserDefaults.standard.object(forKey: "api_token") as! String
            self.headers.updateValue("bearer \(apiToken)",
                forKey: "Authorization")
        }
        else {
            self.headers.updateValue("bearer \(token!)",
                forKey: "Authorization")
        }
    }
    
    func updateHeaders(value: String, forKey key: String) {
        self.headers.updateValue(value, forKey: key)
    }
    
    func setHeadersContentType(value: String) {
        self.headers.updateValue(value, forKey: "Content-Type")
    }
    
    func resetHeaders() {
        self.headers = Alamofire.SessionManager.defaultHTTPHeaders
    }
}
