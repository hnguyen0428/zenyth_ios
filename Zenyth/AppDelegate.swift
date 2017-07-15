//
//  AppDelegate.swift
//  Zenyth
//
//  Created by Hoang on 7/3/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import Alamofire
import SwiftyJSON
//import TwitterKit
//import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Twitter auth
        // Fabric.with([Twitter.self])

        GIDSignIn.sharedInstance().clientID = "726843823228-983fiv45v8m39aoslobaiiqqipvvm2lf.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self

        
        // converted from original objective C
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Twitter 
        // Twitter.sharedInstance().start(withConsumerKey:"KblBowxwd1VQruZvYEYG12Dsq", consumerSecret:"ikGB5s18LZrxjO5oDUP8fqU56xVuN5bzrsWJISWGl6DMeZPDoB")

        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
    
        print("Successfully logged into Google")
        // Perform any operations on signed in user here.

        guard let accessToken = user.authentication.accessToken else { return }

        let route = Route(method: .get, urlString: "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(accessToken)")
        
        let request = Requestor.init(route: route)
        
        request.getJSON { data, error in
            
            if (error != nil) {
                return
            }
        
            self.googleOauthHandle(json: data!, accessToken: accessToken)
            
        }
        
    }
    
    func googleOauthHandle(json: JSON, accessToken: String) {
        // Checks if email is taken
        let request = EmailTakenRequestor.init(email: json["email"].stringValue)
        
        request.getJSON { data, error in
            
            if (error != nil) {
                return
            }

            if (data?["data"].boolValue)! { // email is taken
                print("Email Taken")
                self.googleOauthLogin(accessToken: accessToken)
            } else { // email is available
                print("Email Available")
                self.googleOauthRegister(json: json)
            }
            
        }
    }
    
    func googleOauthLogin(accessToken: String) {
        let parameters: Parameters = [
            "oauth_type": "google"
        ]
        let header: HTTPHeaders = [
            "Authorization": "bearer \(accessToken)"
        ]
        let request = OauthLoginRequestor.init(parameters: parameters, header: header)
        
        request.getJSON { data, error in

            if (error != nil) {
                return
            }
            
            if (data?["success"].boolValue)! {
                let user = User.init(json: data!)
                print("User: \(user)")
            }

        }
    }
    
    func googleOauthRegister(json: JSON) {
        let parameters: Parameters = [
            "username": "hoangGoogle",
            "email": json["email"].stringValue,
            "gender": json["gender"].stringValue,
            "first_name": json["given_name"].stringValue,
            "last_name": json["family_name"].stringValue
        ]
        let request = OauthRegisterRequestor.init(parameters: parameters)
        
        request.getJSON { data, error in
            
            if (error != nil) {
                return
            }

            let user = User.init(json: data!)
            print("User: \(user)")
            
        }
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                          annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
       // Twitter.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

