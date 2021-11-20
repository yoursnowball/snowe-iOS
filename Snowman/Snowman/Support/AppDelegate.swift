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

        UserDefaults.standard.setValue("eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MywidXNlck5hbWUiOiJ0ZXN0IiwiaWF0IjoxNjM3Mzg0MTU1LCJleHAiOjE2OTc4NjQxNTV9.3X6wiGl264cD0j2thBlKPy8ZScFXIJZ0Ymnls4qKmxw", forKey: UserDefaultKey.token)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }

}

