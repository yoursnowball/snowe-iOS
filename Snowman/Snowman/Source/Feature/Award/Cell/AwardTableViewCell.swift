//
//  AwardTableViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

final class AwardTableViewCell: UITableViewCell {

    private let cardView = UIView().then {
        $0.makeRound(16)
        $0.backgroundColor = .blue
    }

    private let goalLabel = UILabel().then {
        $0.font = .spoqa(size: 16, family: .medium)
    }

    private let nameLabel = UILabel().then {
        $0.font = .spoqa(size: 12, family: .regular)
    }

    private let characterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let levelStickerView = LevelStickerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AwardTableViewCell {
    public func updateData(
        with type: Snowe,
        goalText: String,
        nameText: String,
        level: Int
    ) {
        cardView.backgroundColor = type.todoColor.withAlphaComponent(0.2)
        goalLabel.text = goalText
        nameLabel.text = nameText
        characterImageView.image = type.getImage(level: level)
        levelStickerView.level = level
        levelStickerView.type = type
    }
}

extension AwardTableViewCell {
    func setLayouts() {
        contentView.addSubviews(cardView)
        cardView.addSubviews(
            goalLabel,
            nameLabel,
            characterImageView,
            levelStickerView
        )

        cardView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(105)
        }

        goalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(41)
            $0.leading.equalToSuperview().inset(20)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview().inset(20)
        }

        characterImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(73)
            $0.width.equalTo(52)
        }

        levelStickerView.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.width.equalTo(32)
            $0.height.equalTo(16)
        }
    }
}
