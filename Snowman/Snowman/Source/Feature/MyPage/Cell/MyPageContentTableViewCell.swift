//
//  MyPageContentTableViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/24.
//

import UIKit

final class MyPageContentTableViewCell: UITableViewCell {

    private let label = UILabel().then {
        $0.font = .spoqa(size: 15, family: .regular)
    }

    private let iconImageView = UIImageView().then {
        $0.image = Image.chevronRight
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayouts()
        setSelectedBackgroundView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    private func setSelectedBackgroundView() {
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Color.bg_blue
    }

    private func setLayouts() {
        setViewHierarchy()
        setConstraints()
    }

    private func setViewHierarchy() {
        contentView.addSubviews(iconImageView, label)
    }

    private func setConstraints() {
        label.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(iconImageView.snp.leading).offset(-8)
        }

        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }

        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(48)
        }
    }

    public func setTitle(title: String, isOnlyTitle: Bool = false) {
        iconImageView.isHidden = isOnlyTitle
        label.text = title
    }
}
