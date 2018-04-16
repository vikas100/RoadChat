//
//  AppDelegate.swift
//  RoadChat
//
//  Created by Niklas Sauer on 01.03.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import UIKit
import SwiftyBeaver

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
     var window: UIWindow?
    
    // dependency injection
    var container = DependencyContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        container.appDelegate = self
        
        // SwiftyBeaver configuration
        let console = ConsoleDestination()
        log.addDestination(console)
        
        // delete keychain upon first app install
        let userDefaults = container.userDefaults
        let coreData = container.coreData
        
        if userDefaults.bool(forKey: "hasLaunched") == false {
            // remove keychain items
            let credentials = container.credentials
            
            do {
                try credentials.reset()
                log.debug("Cleared keychain upon first app launch.")
                
                // delete all stored data
                coreData.reset()
                
                // update the flag
                userDefaults.set(true, forKey: "hasLaunched")
                userDefaults.synchronize()
            } catch {
                log.error("Failed to clear keychain upon first app launch.")
            }
        }
        
        // start polling for location updates
        container.locationManager.startPolling()
        
        // non-storyboard UI configuration
        window = UIWindow(frame: UIScreen.main.bounds)
        let setupViewController = container.makeSetupViewController()
        show(setupViewController)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        
        // stop polling for location updates
        container.locationManager.stopPolling()
    
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        
        // start polling for location updates
        container.locationManager.startPolling()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // stop polling for location updates
        container.locationManager.stopPolling()
    }

}

extension AppDelegate {
    func show(_ viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
