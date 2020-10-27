//
//  AppDelegate.swift
//  Example
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let menu = MenuViewController()
        menu.deeplink = getDeeplink()
        
        let navController = UINavigationController(rootViewController: menu)
        navController.navigationBar.isTranslucent = false
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func getDeeplink() -> Deeplink? {
        
        if let path = UserDefaults.standard.string(forKey: "deeplink") {
            return Deeplink(path: path)
        } else {
            return nil
        }
    }
}
