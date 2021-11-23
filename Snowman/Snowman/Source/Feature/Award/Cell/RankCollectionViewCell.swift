//
//  RankTableViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

import UIKit

final class RankCollectionViewCell: UICollectionViewCell {

    private let topBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.7)  //TODO:- 컬러 교체
        $0.makeRound(13)
    }

    private let rankLabel = UILabel().then {
        $0.font = .poppins(size: 24)
        $0.textAlignment = .center
        $0.textColor = .lightText // TODO:- 컬러교체
    }

    private let rankImageView = UIImageView().then {
        $0.image = Image.rankAward
        $0.isHidden = true
    }

    private let infoStackView = UIStackView().then {
        $0.spacing = 4
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.axis = .vertical
    }

    private let userNameLabel = UILabel().then {
        $0.font = .spoqa(size: 8, family: .regular)
        $0.textColor = .lightGray // TODO:- 컬러교체
    }

    private let snoweNameLabel = UILabel().then {
        $0.font = .spoqa(size: 14, family: .medium)
        $0.textColor = .black // TODO:- 컬러교체
    }

    private let goalLabel = UILabel().then {
        $0.font = .spoqa(size: 11, family: .regular)
        $0.textColor = .black // TODO:- 컬러교체
    }

    private let levelStickerView = LevelStickerView()

    private let countStackView = UIStackView().then {
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }

    private let todoCountLabel = UILabel().then {
        $0.font = .spoqa(size: 14, family: .bold)
        $0.textColor = .systemBlue // TODO:- 컬러교체
    }

    private let rightLabel = UILabel().then {
        $0.text = "개"
        $0.font = .spoqa(size: 14, family: .regular)
        $0.textColor = .black // TODO:- 컬러교체
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        makeRound(16)
        render()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
        snoweNameLabel.text = nil
        goalLabel.text = nil
        todoCountLabel.text = nil
        rankLabel.text = nil
    }
}

extension RankCollectionViewCell {
    public func updateData(rankUserInfo: RankUserInfo, rank: Int) {
        userNameLabel.text = rankUserInfo.userName
        snoweNameLabel.text = rankUserInfo.name
        goalLabel.text = rankUserInfo.objective
        levelStickerView.level = rankUserInfo.level
        levelStickerView.type = Snowe(rawValue: rankUserInfo.type) ?? .pink
        todoCountLabel.text = "\(rankUserInfo.succeedTodoCount)"

        if rank > 0 && rank < 3 {
            rankImageView.isHidden = false
            rankLabel.textColor = .yellow
        } else {
            rankImageView.isHidden = true
            rankLabel.textColor = .lightText
        }

        rankLabel.text = "\(rank)"

    }
}

extension RankCollectionViewCell {
    private func render() {
        backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)   //TODO:- 컬러 교체
        contentView.addSubviews(
            topBackgroundView,
            rankImageView,
            rankLabel,
            infoStackView,
            levelStickerView,
            countStackView
        )

        infoStackView.addArrangedSubviews(
            userNameLabel,
            snoweNameLabel,
            goalLabel
        )

        countStackView.addArrangedSubviews(
            todoCountLabel, rightLabel
        )

        topBackgroundView.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.bottom.right.equalToSuperview().inset(4)
        }

        rankImageView.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(12)
        }

        rankLabel.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(12)
        }

        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }

        levelStickerView.snp.makeConstraints {
            $0.leading.equalTo(snoweNameLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(snoweNameLabel.snp.centerY)
            $0.height.equalTo(16)
        }

        countStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(22)
        }

    }
}
