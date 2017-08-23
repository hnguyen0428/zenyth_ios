//
//  APIClient.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

/// APIClient used to make API calls
class APIClient {
    
    /// A singleton shared client used by the app
    static let sharedClient = APIClient.init()

    // Prevent instantiation
    private init() {}
    
    /// Headers included with every request
    var headers: HTTPHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    
    /// Client ID used to authenticate the app to use backend's API
    var clientID: String = ""
    
    /**
     Execute a request that returns a JSON response.
     
     - Parameters:
         - route: The route of the request, APIRoute contains the endpoint
         and the HTTP method
         - parameters: Parameters of the request
         - onSuccess: Callback function with JSON parameter upon a successful
         request
         - onFailure: Callback function with JSON parameter upon a failure
         response from the server
         - onRequestError: Callback function with NSError parameter upon a
         request error (such are InternalServerError or Request Timed Out)
     */
    func executeJSON(route: APIRoute,
                     parameters: Parameters = Parameters.init(),
                     onSuccess: JSONCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?) {
        self.setClientId()
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
    
    /**
     Execute an upload request that returns a JSON response.
     
     - Parameters:
         - route: The route of the request, APIRoute contains the endpoint
         and the HTTP method
         - data: The data to be uploaded
         - onSuccess: Callback function with JSON parameter upon a successful
         request
         - onFailure: Callback function with JSON parameter upon a failure
         response from the server
         - onRequestError: Callback function with NSError parameter upon a
         request error (such are InternalServerError or Request Timed Out)
     */
    func executeUpload(route: APIRoute,
                       data: Data,
                       fileKey: String,
                       onSuccess: JSONCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?) {
        self.setClientId()
        let urlString = route.0
        let method = route.1
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: fileKey,
                                     fileName: "file.jpg",
                                     mimeType: "image/jpeg")
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
    
    /**
     Execute an upload request that returns a JSON response.
     
     - Parameters:
     - route: The route of the request, APIRoute contains the endpoint
     and the HTTP method
     - data: array of data to be uploaded
     - onSuccess: Callback function with JSON parameter upon a successful
     request
     - onFailure: Callback function with JSON parameter upon a failure
     response from the server
     - onRequestError: Callback function with NSError parameter upon a
     request error (such are InternalServerError or Request Timed Out)
     */
    func executeUpload(route: APIRoute,
                       data: [Data],
                       fileKey: String,
                       onSuccess: JSONCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?) {
        self.setClientId()
        let urlString = route.0
        let method = route.1
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for imageData in data {
                multipartFormData.append(imageData, withName: fileKey,
                                         fileName: "file.jpg",
                                         mimeType: "image/jpeg")
            }
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
    
    /**
     Executes a download request that returns Data.
     
     - Parameters:
        - route: The route of the request, APIRoute contains the endpoint
        and the HTTP method
        - onSuccess: Callback function with Data parameter upon a successful
        request
        - onRequestError: Callback function with NSError parameter upon a
        request error (such are InternalServerError or Request Timed Out)
     */
    func executeDownload(route: APIRoute,
                         onSuccess: DataCallback?,
                         onRequestError: ErrorCallback?) {
        self.setClientId()
        
        let urlString = route.0
        
        Alamofire.request(urlString).response {
            response in
            if let data = response.data {
                onSuccess?(data)
                self.resetHeaders()
            }
            if let error = response.error {
                print("ERROR: \(error)")
                onRequestError?(error as! NSError)
            }
        }
    }
    
    /**
     Set authorization token
     
     - Parameters:
        - token: token to be set, if not provided, the default authorization
        is the api_token stored in UserDefaults
     */
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
    
    /**
     Set Client-ID to use REST API
     */
    func setClientId() {
        self.headers.updateValue(clientID, forKey: "Client-ID")
    }
    
    /**
     Update a headers key. If the key is not there, create one
     */
    func updateHeaders(value: String, forKey key: String) {
        self.headers.updateValue(value, forKey: key)
    }
    
    /**
     Set Content-Type of the header
     */
    func setHeadersContentType(value: String) {
        self.headers.updateValue(value, forKey: "Content-Type")
    }
    
    /**
     Reset to the default HTTP header
     */
    func resetHeaders() {
        self.headers = Alamofire.SessionManager.defaultHTTPHeaders
    }
}
