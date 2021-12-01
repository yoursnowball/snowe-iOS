//
//  UIImage+.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit.UIImage

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
