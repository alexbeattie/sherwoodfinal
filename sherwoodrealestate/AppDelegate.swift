//
//  AppDelegate.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "19f5e386d1a390779d1b844298e6078f00a1b819"
            ParseMutableClientConfiguration.clientKey = "bd18ac1968d58f6bfd771b2711da33e2aba69ea9"
            ParseMutableClientConfiguration.server = "http://35.173.249.78:80/parse"
        })
        
        Parse.initialize(with: parseConfiguration)

        saveInstallationObject()
        
//        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
//            // 2
//            let aps = notification["aps"] as! [String: AnyObject]
//            _ = NewsItem.makeNewsItem(aps)
//            // 3
//            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//        }

        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
//        let layout = UICollectionViewFlowLayout()
        window?.rootViewController = MainTabBarController()

//        window?.rootViewController = UINavigationController(rootViewController: HomeViewController(collectionViewLayout: layout))
//        window?.rootViewController = CustomTabBarController()

//        window?.tintColor = UIColor.black
//        window?.backgroundColor = UIColor.yellow
        

        // get rid of black bar underneath navbar
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]

//        let attrs = [
//            NSAttributedStringKey.foregroundColor: UIColor.red,
//            NSAttributedStringKey.font: UIFont(name: "Georgia-Bold", size: 24)!
//        ]
//
//        UINavigationBar.appearance().titleTextAttributes = attrs

//        UIapplication.statusBarStyle = .default
//        navigationBarAppearace.tintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = UIColor(red: 66, green: 66, blue: 66, alpha: 1)
        
//        let statusBarBackgroundView = UIView()
//        statusBarBackgroundView.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246)
        
//        window?.addSubview(statusBarBackgroundView)
//        window?.addConstraintsWithFormat("H:|[v0]|", views: statusBarBackgroundView)
//        window?.addConstraintsWithFormat("V:|[v0(20)]", views: statusBarBackgroundView)


        registerForPushNotifications()
        return true
    }
    func saveInstallationObject(){
        if let installation = PFInstallation.current(){
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully connected your app to Back4App!")
                } else {
                    if let myError = error{
                        print(myError.localizedDescription)
                    }else{
                        print("Uknown error")
                    }
                }
            }
        }
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

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()

        }
    }
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async() {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }


}

