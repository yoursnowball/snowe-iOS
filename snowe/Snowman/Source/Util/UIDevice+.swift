//
//  UIDevice+.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/30.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

