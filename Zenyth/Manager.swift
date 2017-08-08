//
//  Requests.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Manager {
    var needsAuthorization: Bool = false
    
    func executeJSON(urlString: String, method: HTTPMethod,
                 parameters: Parameters = Parameters.init(),
                 headers: HTTPHeaders = HTTPHeaders.init(),
                 onSuccess: JSONCallback?,
                 onFailure: JSONCallback?,
                 onRequestError: ErrorCallback?) {
        
        var headers = headers
        if self.needsAuthorization {
            let apiToken: String =
                UserDefaults.standard.object(forKey: "api_token") as! String
            headers.updateValue("Authorization",
                                forKey: "bearer \(apiToken)")
        }
        
        Alamofire.request(urlString, method: method, parameters: parameters,
                          headers: headers).responseJSON {
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
    
    func setAuthorization() {
        self.needsAuthorization = true
    }
}
