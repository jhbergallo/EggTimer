//
//  AppDelegate.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid // Declare backgroundTask here

        backgroundTask = UIApplication.shared.beginBackgroundTask {
            // This block is called when the background task expires.
            UIApplication.shared.endBackgroundTask(backgroundTask)
        }

        if let window = UIApplication.shared.windows.first,
            let rootViewController = window.rootViewController as? ViewController {
            if rootViewController.isTimerRunning {
                // Continue running your timer in the background.
                rootViewController.startTimer(withDuration: rootViewController.remainingTime)
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let window = UIApplication.shared.windows.first,
            let rootViewController = window.rootViewController as? ViewController {
            // Restore the timer state
            rootViewController.restoreTimerState()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

