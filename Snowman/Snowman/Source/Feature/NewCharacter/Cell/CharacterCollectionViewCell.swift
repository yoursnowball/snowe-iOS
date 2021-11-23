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

    private let characterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        round()
        setLayouts()
        makeCollectionViewCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
    }
}
extension CharacterCollectionViewCell {
    public func setCharacterImage(with image: UIImage) {
        characterImageView.image = image
    }
}

extension CharacterCollectionViewCell {
    private func round() {
        makeRound(24)
        layer.borderColor = Color.line_blue.cgColor
    }

    private func makeCollectionViewCell() {
        layer.borderWidth =  isSelected ? 1 : 0

        contentView.backgroundColor = isSelected ?
            Color.bg_blue : Color.Gray100

        checkImageView.image = isSelected ?
            UIImage(named: "24_check_blue") : UIImage(systemName: "circle")

        checkImageView.tintColor = isSelected ?
            Color.bg_blue : Color.Gray300
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
            $0.width.height.equalTo(23)
        }

        characterImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(180)
        }
    }
}
