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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AwardTableViewCell {
    //TODO:- 캐릭터와 이미지는 enum 으로 관리 후 교체
    public func updateData(
        with backgroundColor: UIColor,
        goalText: String,
        nameText: String,
        characterImage: UIImage
    ) {
        cardView.backgroundColor = backgroundColor
        goalLabel.text = goalText
        nameLabel.text = nameText
        characterImageView.image = characterImage
    }
}

extension AwardTableViewCell {
    func setLayouts() {
        contentView.addSubviews(cardView)
        cardView.addSubviews(
            goalLabel,
            nameLabel,
            characterImageView
        )

        cardView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(105)
        }

        goalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(48)
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
    }
}
