//
//  AppDelegate.swift
//  DragCardContainer
//
//  Created by jun on 2021/10/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        //
        let vc = ViewController()
        let navi = NavigationController(rootViewController: vc)
        self.window?.rootViewController = navi
        //
        return true
    }
}

