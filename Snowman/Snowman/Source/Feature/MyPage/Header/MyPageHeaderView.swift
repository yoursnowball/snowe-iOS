//
//  MyPageHeaderView.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/24.
//

import UIKit

import SnapKit

final class MyPageSectionHeaderView: UIView {

    private let titleLabel = UILabel().then {
        $0.font = .spoqa(size: 14, family: .medium)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        initSectionHeaderView()
        setLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initSectionHeaderView() {
        backgroundColor = .white
    }

    private func setLayouts() {
        setViewHierarchy()
        setConstraints()
    }

    private func setViewHierarchy() {
        addSubview(titleLabel)
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-12)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }

    public func setTitleText(title: String) {
        titleLabel.text = title
    }
}
