//
//  JSONHelper.swift
//  Zenyth
//
//  Created by Hoang on 8/10/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON

func getJSONFromFile(filename: String) -> JSON? {
    if let path = Bundle.main.path(forResource: filename, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let jsonObj = JSON(data: data)
            if jsonObj != JSON.null {
                return jsonObj
            } else {
                print("Could not get json from file, make sure that file contains valid json.")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    } else {
        print("Invalid filename/path.")
    }
    
    return nil
}
