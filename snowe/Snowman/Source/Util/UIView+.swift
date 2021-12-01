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

    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) {
        if let constraint = (constraints.filter { $0.firstAttribute == attribute }.first) {
            constraint.constant = constant
            layoutIfNeeded()
        }
    }

    func makeRound(_ radius: CGFloat = 10) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }

    func makeRoundedSpecificCorner(corners: UIRectCorner, cornerRadius: Double) {
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }
}
