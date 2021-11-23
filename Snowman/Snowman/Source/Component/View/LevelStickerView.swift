//
//  LevelStickerView.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import UIKit

/// level sticker 높이는 무조건 16
final class LevelStickerView: UIView {

    public var type: Snowe = .orange {
        didSet {
            color()
        }
    }

    public var level: Int = 0 {
        didSet {
            label.text = "lv \(level)"
            render()
        }
    }

    private let label = UILabel().then {
        $0.font = .spoqa(size: 11, family: .medium)
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
        makeRound(8)
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
        label.textColor = type.color
        layer.borderColor = type.color.cgColor
        backgroundColor = type.color.withAlphaComponent(0.1)
    }
}
