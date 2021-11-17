//
//  BaseNavigationController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/18.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAppearance()
        self.delegate = self
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let item = UIBarButtonItem(
            title: " ",
            style: .plain,
            target: nil,
            action: nil
        )
        viewController.navigationItem.backBarButtonItem = item
    }
}

extension BaseNavigationController {
    private func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        //TODO:- tintColor 교체
        navigationBar.tintColor = .darkGray
    }
}
