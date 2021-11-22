//
//  UITextField+.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import UIKit.UITextField

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.height))
        leftView = paddingView
        leftViewMode = ViewMode.always
    }
}
