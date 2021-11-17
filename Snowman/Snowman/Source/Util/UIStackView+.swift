//
//  UIStackView+.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/18.
//

import UIKit.UIStackView

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
