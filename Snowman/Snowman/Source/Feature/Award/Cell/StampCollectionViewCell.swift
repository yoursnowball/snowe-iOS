//
//  StampCollectionViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/28.
//

import UIKit

import Then
import SnapKit

class StampCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let nameLabel = UILabel().then {
        $0.text = " "
        $0.font = .spoqa(size: 14, family: .regular)
        $0.textAlignment = .center
    }

    // MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        render()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }

    // MARK: - Functions
    private func render() {
        contentView.backgroundColor = .white
    }

    private func setLayout() {
        setViewHierachy()
        setConstraints()
    }

    private func setViewHierachy() {
        contentView.addSubviews(imageView, nameLabel)
    }

    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-37)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(imageView)
        }
    }

    public func setData(stamp: Stamp) {
        imageView.image = stamp.hasStamp ? Image.stampComplete : Image.stampUnabled
        nameLabel.text = stamp.name
        nameLabel.textColor = stamp.hasStamp ? Color.button_blue : Color.text_Teritary
    }

}
