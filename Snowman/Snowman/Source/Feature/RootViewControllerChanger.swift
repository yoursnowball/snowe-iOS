//
//  RootViewControllerChanger.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/22.
//

import UIKit

class RootViewControllerChanger {
    typealias Home = HomeViewController
    typealias SignIn = StartSignInViewController

    static func updateRootViewController() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        if UserDefaults.standard.bool(forKey: UserDefaultKey.loginStatus) {
            guard let token = UserDefaults.standard.value(forKey: UserDefaultKey.fcmToken) as? String else { return }
            NetworkService.shared.user.postPushToken(fcm: token) { _ in }
            appDelegate?.window?.rootViewController = HomeNavigationViewController(rootViewController: Home())
        } else {
            appDelegate?.window?.rootViewController = BaseNavigationController(rootViewController: SignIn())
        }
    }
}
