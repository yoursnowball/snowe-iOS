//
//  AwardTableViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

final class AwardTableViewCell: UITableViewCell {

    private let cardView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AwardTableViewCell {
    func setLayouts() {
        contentView.addSubviews(cardView)
    }
}
