//
//  ContentSizedTableView.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import UIKit

final class ContentSizedTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()

        if self.isHidden {
            return CGSize(width: UIView.noIntrinsicMetric, height: 50)
        } else {
            return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        }
    }
}
