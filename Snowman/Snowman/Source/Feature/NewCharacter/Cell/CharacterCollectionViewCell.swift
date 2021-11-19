//
//  CharacterCollectionViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {

    override var isSelected: Bool {
        didSet {
            makeCollectionViewCell()
        }
    }

    private let checkImageView = UIImageView()

    private let characterImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCollectionViewCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension CharacterCollectionViewCell {
    private func makeCollectionViewCell() {
        layer.masksToBounds = true
        layer.cornerRadius = 24
        layer.borderWidth =  isSelected ? 1 : 0
        layer.borderColor = UIColor.systemBlue.cgColor

        contentView.backgroundColor = isSelected ?
            .systemBlue.withAlphaComponent(0.3) : .lightGray
    }
}

extension CharacterCollectionViewCell {
    private func setLayouts() {
        setViewHierachies()
        setConstraints()
    }

    private func setViewHierachies() {
        contentView.addSubviews(
            checkImageView,
            characterImageView
        )
    }

    private func setConstraints() {
        checkImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().inset(20)
        }

        characterImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(180)
        }
    }
}
