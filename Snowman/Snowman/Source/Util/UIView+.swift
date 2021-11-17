//
//  UIView+.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/18.
//

import UIKit.UIView

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
