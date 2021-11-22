//
//  RootViewControllerChanger.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/22.
//

import UIKit

class RootViewControllerChanger {
    static func updateRootViewController() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        if UserDefaults.standard.bool(forKey: UserDefaultKey.loginStatus) {
            appDelegate?.window?.rootViewController = BaseNavigationController(rootViewController: HomeViewController())
        } else {
            appDelegate?.window?.rootViewController = BaseNavigationController(rootViewController: StartSignInViewController())
        }
    }
}
