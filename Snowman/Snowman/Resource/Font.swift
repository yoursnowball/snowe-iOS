//
//  Font.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/14.
//

import UIKit.UIFont

extension UIFont {

    enum Family: String {
        case bold, medium, regular
    }

    static func spoqa(size: CGFloat, family: Family) -> UIFont {
        return UIFont(name: "SpoqaHanSansNeo-\(family)", size: size)!
    }
}
