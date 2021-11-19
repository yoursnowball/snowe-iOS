//
//  PopUpViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

class PopUpViewController: UIViewController {
    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
    }

    private let titleLabel = UILabel().then {
        $0.font = .spoqa(size: 20, family: .bold)
        $0.text = "눈덩이 생성 완료!"
    }

    private let characterImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.fill")
    }

    private let nameLabel = UILabel().then {
        $0.font = .spoqa(size: 16, family: .medium)
        $0.text = "수줍은 눈사람"
    }

    private let discriptionLabel = UILabel().then {
        $0.font = .spoqa(size: 16, family: .regular)
        $0.text = "토익 900점 달성하기"
    }

    private lazy var okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = .spoqa(size: 18, family: .bold)

        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10

        $0.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        setLayouts()
    }
}

extension PopUpViewController {
    private func render() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
}

extension PopUpViewController {
    @objc
    public func buttonDidTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension PopUpViewController {
    private func setLayouts() {
        setViewHierachies()
        setConstraints()
    }

    private func setViewHierachies() {
        view.addSubviews(
            backgroundView
        )

        backgroundView.addSubviews(
            titleLabel,
            characterImageView,
            nameLabel,
            discriptionLabel,
            okButton
        )
    }

    private func setConstraints() {
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(backgroundView.snp.width).multipliedBy(1.6)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(75)
        }

        characterImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(180)
            $0.top.equalTo(titleLabel.snp.bottom).offset(75)
        }

        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(characterImageView.snp.bottom).offset(17)
        }

        discriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(17)
        }

        okButton.snp.makeConstraints {
            $0.height.equalTo(53)
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.bottom.equalToSuperview().offset(-28)
        }

    }
}
