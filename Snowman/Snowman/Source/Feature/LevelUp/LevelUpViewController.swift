//
//  LevelUpViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/29.
//

import UIKit

final class LevelUpViewController: BaseViewController {

    public var snoweImage: UIImage? = UIImage() {
        didSet {
            snoweImageView.image = snoweImage
            setLayouts()
        }
    }

    private let congratulationImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Image.levelUpCongratulation
    }

    private let snoweImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let congratulationLabel = UILabel().then {
        $0.text = """
        축하합니다🎉
        당신의 눈사람이 레벨업했어요!
        """
        $0.textAlignment = .center
        $0.font = .spoqa(size: 16, family: .medium)
        $0.textColor = Color.text_Primary
        $0.numberOfLines = 2
    }

    private lazy var okButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .spoqa(size: 18, family: .regular)
        $0.setBackgroundColor(Color.button_blue, for: .normal)
        $0.makeRound(10)
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.bg_blue
    }

    @objc
    private func buttonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension LevelUpViewController {
    func setLayouts() {
        setViewHierachies()
        setConstraints()
    }

    func setViewHierachies () {
        view.addSubviews(
            congratulationImageView,
            snoweImageView,
            congratulationLabel,
            okButton
        )
    }

    func setConstraints() {
        congratulationImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalToSuperview().offset(90)
            $0.height.equalTo(congratulationImageView.snp.width).multipliedBy(1.1)
        }

        snoweImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(250)
        }

        congratulationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(snoweImageView.snp.bottom).offset(58)
        }

        okButton.snp.makeConstraints {
            $0.height.equalTo(53)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
        }
    }
}
