//
//  AppDelegate.swift
//  PoNavigationBar
//
//  Created by 黄中山 on 2020/4/1.
//  Copyright © 2020 potato. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let root = PoNavigationController(rootViewController: ViewController())
        root.defaultNavigationBarConfigure.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17),
                                                                  .foregroundColor: UIColor.red]
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        return true
    }

}

