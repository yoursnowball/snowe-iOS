//
//  SnoweCollectionViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import UIKit

class SnoweCollectionViewCell: UICollectionViewCell {

    private let characterImageView = UIImageView().then {
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
}

extension SnoweCollectionViewCell {
    private func render() {
        contentView.addSubviews(characterImageView)

        characterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
