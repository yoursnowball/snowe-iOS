//
//  LevelStickerView.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import UIKit

final class LevelStickerView: UIView {

    public var type: Snowe = .orange {
        didSet {
            color()
        }
    }

    public var level: Int = 0 {
        didSet {
            label.text = "lv \(level)"
            label.font = .spoqa(size: 11, family: .medium)
            makeRound(8)
            render()
        }
    }

    public var text: String = "" {
        didSet {
            label.text = text
            label.font = .spoqa(size: 14, family: .bold)
            makeRound(27/2)
            render()
        }
    }

    private let label = UILabel().then {
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeBorder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LevelStickerView {
    private func makeBorder() {
        layer.borderWidth = 0.5
    }

    private func render() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2.5)
            $0.leading.trailing.equalToSuperview().inset(6.5)
        }
    }

    private func color() {
        label.textColor = type.lineColor
        layer.borderColor = type.lineColor.cgColor
        backgroundColor = type.pinBgColor
    }
}
