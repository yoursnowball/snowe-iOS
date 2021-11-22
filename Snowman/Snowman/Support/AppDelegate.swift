//
//  AppDelegate.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/07.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UserDefaults.standard.setValue("eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwidXNlck5hbWUiOiJ0ZXN0IiwiaWF0IjoxNjM3NDI0ODI5LCJleHAiOjE2OTc5MDQ4Mjl9.7U4beCgjbEaBs1unE51teHnUMVX2OuMp0fSGRkZz3xM", forKey: UserDefaultKey.token)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = BaseNavigationController(rootViewController: HomeViewController())
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }

}

