//
//  StampModalViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/28.
//

import UIKit

import SnapKit
import Then

class StampModalViewController: UIViewController {

    // MARK: - Properties
    private var stamp: Stamp?

    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
    }

    private let stampImageView = UIImageView()

    private let nameLabel = UILabel().then {
        $0.font = .spoqa(size: 18, family: .bold)
        $0.textAlignment = .center
    }

    private let stickerView = LevelStickerView().then {
        $0.type = .blue
        $0.text = "Mission"
    }

    private let infoLabel = UILabel().then {
        $0.font = .spoqa(size: 13, family: .regular)
        $0.textColor = Color.text_Primary
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    // MARK: - View Life Cycle

    init(stamp: Stamp) {
        super.init(nibName: nil, bundle: nil)
        self.stamp = stamp
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeRoundedSpecificCorner()
    }

    // MARK: - Functions
    private func makeRoundedSpecificCorner() {
        backgroundView.makeRoundedSpecificCorner(corners: [.topLeft, .topRight], cornerRadius: 20)
    }

    private func setLayout() {
        setViewHierachy()
        setConstraints()
    }

    private func setViewHierachy() {
        view.addSubview(backgroundView)
        backgroundView.addSubviews(stampImageView, nameLabel, stickerView, infoLabel)
    }

    private func setConstraints() {

        backgroundView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(290)
        }

        stampImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(42)
            $0.width.height.equalTo(100)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(stampImageView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(42)
        }

        stickerView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(27)
        }

        infoLabel.snp.makeConstraints {
            $0.top.equalTo(stickerView.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(42)
        }

    }

    private func setData() {
        guard let stamp = stamp else {return}
        nameLabel.text = stamp.name
        infoLabel.text = stamp.info
        stampImageView.image = stamp.hasStamp ? Image.stampComplete : Image.stampUnabled
    }

}
