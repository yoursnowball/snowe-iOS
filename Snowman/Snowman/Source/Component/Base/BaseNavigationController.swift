//
//  BaseNavigationController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/18.
//

import UIKit

class BaseNavigationController: UINavigationController {

    private var backButtonAppearance: UIBarButtonItemAppearance {
        let backButtonAppearance = UIBarButtonItemAppearance()

        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 0.0)
        ]

        return backButtonAppearance
    }

    private var backButtonImage: UIImage? {
        return UIImage(systemName: "chevron.backward")?
            .resized(to: CGSize(width: 13, height: 21))
            .withAlignmentRectInsets(
                UIEdgeInsets(
                    top: 0.0,
                    left: -10.0,
                    bottom: 0.0,
                    right: 0.0
                )
            )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAppearance()
    }
}

extension BaseNavigationController {
    private func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .font: UIFont.spoqa(size: 16, family: .medium),
            .foregroundColor: Color.text_Primary
        ]

        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.backButtonAppearance = backButtonAppearance

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = Color.text_Primary
    }
}
