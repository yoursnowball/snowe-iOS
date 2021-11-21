//
//  SnoweCollectionViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import UIKit

class SnoweCollectionViewCell: UICollectionViewCell {

    public let characterImageView = UIImageView().then {
        $0.image = Image.bigMakecharacterCard
        $0.contentMode = .scaleAspectFit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        render()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = Image.bigMakecharacterCard
        characterImageView.alpha = 0.6
    }
}

extension SnoweCollectionViewCell {
    public func updateData(goal: GoalResponse?) {
        if let goal = goal {
            characterImageView.image = CharacterType(rawValue: goal.type)?.getImage(level: goal.level)
        }
    }

}

extension SnoweCollectionViewCell {
    private func render() {
        contentView.addSubviews(characterImageView)

        characterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
