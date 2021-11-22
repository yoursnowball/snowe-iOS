//
//  HomeNavigationViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

import UIKit

class HomeNavigationViewController: BaseNavigationController {

  // MARK: - Properties
      private lazy var logoItem = UIBarButtonItem().then {
          let imageView = UIImageView(image: Image.snoweLogo.resized(to: CGSize(width: 100, height: 24)))
          $0.customView = imageView
      }

      private lazy var hamburgerItem = UIBarButtonItem().then {
          $0.customView = makeBarButtonItem(image: Image.hamburger, tag: 0)
      }

      private lazy var notificationItem = UIBarButtonItem().then {
          $0.customView = makeBarButtonItem(image: Image.notification, tag: 1)
      }

      private lazy var heartItem = UIBarButtonItem().then {
          $0.customView = makeBarButtonItem(image: Image.heart, tag: 2)
      }

   // MARK: - View Life Cycle
      override init(rootViewController: UIViewController) {
          super.init(rootViewController: rootViewController)
          initNavigationItem(navigationItem: rootViewController.navigationItem)
      }

      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

      override func viewDidLoad() {
          super.viewDidLoad()
      }

      private func initNavigationItem(navigationItem: UINavigationItem?) {
          navigationItem?.rightBarButtonItems = [hamburgerItem, notificationItem, heartItem]
          navigationItem?.leftBarButtonItem = logoItem
      }

      private func makeBarButtonItem(image: UIImage, tag: Int) -> UIButton {
          let button = UIButton(type: .custom)
          button.tag = tag
          button.setImage(image, for: .normal)
          button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
          button.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
          return button
      }

    @objc
    private func buttonDidTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            break
        case 1:
            pushViewController(NotificationViewController(), animated: true)
        case 2:
            pushViewController(TopTabBarViewController(), animated: true)
        default:
            break
        }
    }

}
