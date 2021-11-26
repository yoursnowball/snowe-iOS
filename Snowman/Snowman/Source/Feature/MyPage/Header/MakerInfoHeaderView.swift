//
//  MakerInfoHeaderView.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/25.
//

import UIKit

import SnapKit

final class MakerInfoHeaderView: UIView {

    private let textImageView = UIImageView().then {
        $0.image = UIImage(named: "makerHeaderImage")
        $0.contentMode = .scaleAspectFit
    }

    private let seperator = UIView().then {
        $0.backgroundColor = Color.Gray300
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayouts() {
        setViewHierarchy()
        setConstraints()
    }

    private func setViewHierarchy() {
        addSubview(textImageView)
        addSubview(seperator)
    }

    private func setConstraints() {
        seperator.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        textImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(268)
            $0.height.equalTo(150)
        }
    }
}
