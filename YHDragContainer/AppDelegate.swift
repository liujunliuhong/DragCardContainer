//
//  AppDelegate.swift
//  YHDragContainer
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let vc = ViewController()
        let navi = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navi
        
        return true
    }
}

