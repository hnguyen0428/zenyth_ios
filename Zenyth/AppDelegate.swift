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
import GoogleMaps
import GooglePlaces
//import TwitterKit
//import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Read the Info.plist file to set the client id for the APIClient
        var infoDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            infoDict = NSDictionary(contentsOfFile: path)
        }
        if infoDict != nil {
            let clientID = infoDict?.object(forKey: "CLIENT_ID") as! String
            APIClient.sharedClient.clientID = clientID
        }
        
        // Read the GoogleService-Info.plist file to set the client id for the
        // Google signin instance
        var googleDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            googleDict = NSDictionary(contentsOfFile: path)
        }
        if googleDict != nil {
            let clientID = googleDict?.object(forKey: "CLIENT_ID") as! String
            GIDSignIn.sharedInstance().clientID = clientID
        }

        GIDSignIn.sharedInstance().delegate = self
        
        // Converted from original objective C
        FBSDKApplicationDelegate.sharedInstance().application(application,
                                didFinishLaunchingWithOptions: launchOptions)
        
        // Twitter 
        // Twitter.sharedInstance().start(withConsumerKey:"KblBowxwd1VQruZvYEYG12Dsq", consumerSecret:"ikGB5s18LZrxjO5oDUP8fqU56xVuN5bzrsWJISWGl6DMeZPDoB")
        
        // Set the google map api key
        GMSServices.provideAPIKey("AIzaSyDbce3U3e0teGEnQM54kBu_r2kDGEGcOz0")
        GMSPlacesClient.provideAPIKey("AIzaSyAM71tm5Rgc1Z7TbIOqHhQvESu7gjqmcFI")
        
        var navbarAppearance = UINavigationBar.appearance()
        navbarAppearance.tintColor = UIColor.white
        navbarAppearance.barTintColor = UIColor.white
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
    
        // Perform any operations on signed in user here.

        guard let accessToken = user.authentication.accessToken else { return }
        guard let idToken = user.authentication.idToken else { return }
        
        let urlString = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(accessToken)"
        // Requesting for user's information from google
        Alamofire.request(urlString, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                self.googleOauthHandle(json: JSON(value), idToken: idToken)
                
            case .failure(let error):
                debugPrint(response)
                print(error)
            }
        }
    }
    
    /**
     Handle Google OAuth. First check if the email has been taken. If yes then
     it will try to log the user in. If not then it will switch to UsernameController
     in order to prompt user to enter a username for the new account
     
     - Parameter json: JSON object retrieved from google
     - Parameter idToken: google id token
     */
    func googleOauthHandle(json: JSON, idToken: String) {
        // Checks if email is taken
        let email = json["email"].stringValue
        CredentialManager().validateEmail(email: email,
                                          onSuccess:
            { data in
                if data["taken"].boolValue{ // email is taken
                    self.googleOauthLogin(idToken: idToken, json: json)
                } else { // email is available
                    // Access the storyboard and fetch an instance of the view controller
                    let storyboard = UIStoryboard(name: "Main", bundle: nil);
                    let viewController: UsernameController =
                        storyboard.instantiateViewController(
                            withIdentifier: "UsernameEmailController")
                            as! UsernameController;
                    
                    // Then push that view controller onto the navigation stack
                    let rootViewController = self.window!.rootViewController
                        as! UINavigationController;
                    rootViewController.pushViewController(viewController,
                                                          animated: true);
                    viewController.oauthJSON = json
                    viewController.messageFromOauth = "changeButtonTargetGoogle"
                    viewController.googleToken = idToken
                }
        })
    }
    
    /**
     Called when email has been taken. Attempt to log the user in with their
     Google
     
     - Parameter idToken: google id token
     - Parameter json: JSON object with user info retrieved from google
     */
    func googleOauthLogin(idToken: String, json: JSON) {
        let rootViewController = self.window!.rootViewController
            as! UINavigationController
        let viewController = rootViewController.topViewController!
        
        let indicator = viewController.requestLoading(view: viewController.view)
        let email = json["email"].stringValue
        let oauthType = "google"
        LoginManager().oauthLogin(withEmail: email,
                                  oauthType: oauthType,
                                  accessToken: idToken,
                                  onSuccess:
            { user, apiToken in
                viewController.requestDoneLoading(view: viewController.view,
                                                  indicator: indicator)
                LoginController.saveLoggedInUserInfo(user: user, apiToken: apiToken)
                self.transitionToHome()
        }, onFailure: { json in
            viewController.requestDoneLoading(view: viewController.view,
                                              indicator: indicator)
            if json["data"]["mergeable"].boolValue {
                let message = json["message"].stringValue
                let alert = UIAlertController(title: nil,
                                              message: message,
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                    action in
                    self.mergeAccount(idToken: idToken, email: email)
                }))
                viewController.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    /**
     Called when user agrees to merge account. This will merge the new oauth
     account to the preexisted account
     
     - Parameter idToken: google id token
     - Parameter email: gmail retrieved from the google account
     */
    func mergeAccount(idToken: String, email: String) {
        let rootViewController = self.window!.rootViewController
            as! UINavigationController
        let viewController = rootViewController.topViewController!
        let indicator = viewController.requestLoading(view: viewController.view)
        
        let oauthType = "google"
        RegistrationManager().oauthMergeAccount(withEmail: email,
                                                oauthType: oauthType,
                                                accessToken: idToken,
                                                onSuccess:
            { user, apiToken in
                viewController.requestDoneLoading(view: viewController.view,
                                                  indicator: indicator)
                LoginController.saveLoggedInUserInfo(user: user, apiToken: apiToken)
                self.transitionToHome()
        })
    }
    
    /**
     Transition to the Home page of the app. Called when successfully logged in
     */
    func transitionToHome() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let feedController = UINavigationController(rootViewController: FeedController())
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve,
                          animations: {
            self.window!.rootViewController = feedController
        }, completion: nil)
    }
    
    func application(_ app: UIApplication, open url: URL, options:
        [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        let handled = FBSDKApplicationDelegate.sharedInstance().application(
            app, open: url, sourceApplication:
            options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:
            options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
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

