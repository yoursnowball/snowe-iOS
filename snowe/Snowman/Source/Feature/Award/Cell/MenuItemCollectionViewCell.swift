//
//  MenuItemCollectionViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

import SnapKit

class MenuItemCollectionViewCell: UICollectionViewCell {

    override var isSelected: Bool {
        didSet {
            menuTitle.textColor = isSelected ?
            Color.button_blue : Color.Gray500
        }
    }

    private let menuTitle = UILabel().then {
        $0.font = .spoqa(size: 14, family: .medium)
        $0.textColor = Color.Gray500
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MenuItemCollectionViewCell {
    public func setData(title: String) {
        menuTitle.text = title
    }
}

extension MenuItemCollectionViewCell {
    private func setLayouts() {
        addSubview(menuTitle)
        menuTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
