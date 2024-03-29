//
//  NotificationTableViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/22.
//

import UIKit

import SnapKit
import Then

final class NotificationTableViewCell: UITableViewCell {

    private let titleLabel = UILabel().then {
        $0.font = .spoqa(size: 14, family: .bold)
        $0.textColor = Color.text_Primary
    }

    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .spoqa(size: 14, family: .regular)
        $0.textColor = Color.text_Primary
    }

    private let timeLabel = UILabel().then {
        $0.font = .spoqa(size: 10, family: .regular)
        $0.textColor = Color.button_blue
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSelectedBackgroundView()
        setLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentLabel.text = nil
        timeLabel.text = nil
    }

    private func setSelectedBackgroundView() {
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Color.bg_blue
    }
}

extension NotificationTableViewCell {
    public func updateData(response: AlarmResponse) {
        titleLabel.text = response.title
        contentLabel.text = response.body
        timeLabel.text = response.alarmAt
    }
}

extension NotificationTableViewCell {
    private func setLayouts() {
        contentView.addSubviews(
            titleLabel,
            contentLabel,
            timeLabel
        )

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(56)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(16)
        }

        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(56)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
        }

        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(56)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(contentLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
