//
//  AppDelegate.swift
//  cards
//
//  Created by Gaurang Lathiya on 24/12/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Set Navigation, status bar, UITableViewCell UI
        self.initUI()
        //Starts monitoring network reachability status changes
        ReachabilityManager.shared.startMonitoring()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // Stops monitoring network reachability status changes
        ReachabilityManager.shared.stopMonitoring()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //Starts monitoring network reachability status changes
        ReachabilityManager.shared.startMonitoring()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func initUI() {
        // Set Default background color for UITableView cell.. some cases - iPad having default color is white
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        // Set Navigation bar
        self.setNavigationBarUI()
    }
    
    func setNavigationBarUI() {
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().prefersLargeTitles = false
        }
        // Common setting for transparent navigation bar
        UINavigationBar.appearance().barTintColor = UIColor.clear
        // Set button color
        UINavigationBar.appearance().tintColor = UIColor.white
        
        // Set default back button image
        let backImage = UIImage(named: "icon_navBack")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage?.withRenderingMode(.alwaysOriginal)
        
        // Remove back button text : "Back"
        if #available(iOS 11, *) {
            UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
            UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        } else {
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -60, vertical: -60), for: .default)
        }
        
        // Set Navigation title
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
}

