//
//  UITableVIew+Reusable.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/18.
//

import UIKit.UITableView

extension UITableViewCell: Reusable { }
extension UITableViewHeaderFooterView: Reusable { }

extension UITableView {
    func registerReusableCell<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
  }

    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier,
                                             for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
  }

    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)

  }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: Reusable {
        guard let footer = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue header footer view: \(T.reuseIdentifier)")
        }
        return footer
  }
}
