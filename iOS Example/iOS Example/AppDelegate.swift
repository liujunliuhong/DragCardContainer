//
//  AppDelegate.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let vc = ViewController()
        let navi = UINavigationController(rootViewController: vc)
        window?.rootViewController = navi
        
        return true
    }
}

