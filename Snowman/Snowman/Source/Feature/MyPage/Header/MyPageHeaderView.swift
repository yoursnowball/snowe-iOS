//
//  MyPageHeaderView.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/24.
//


import UIKit

import SnapKit

final class MyPageSectionHeaderView: UITableViewHeaderFooterView {

    private let titleLabel = UILabel().then {
        $0.font = .spoqa(size: 14, family: .bold)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSectionHeaderView()

        setLayouts()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("coder doesn't exist")
    }

    private func initSectionHeaderView() {
        contentView.backgroundColor = .white
    }

    private func setLayouts() {
        setViewHierarchy()
        setConstraints()
    }

    private func setViewHierarchy() {
        contentView.addSubview(titleLabel)
    }

    private func setConstraints() {
        contentView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }

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
