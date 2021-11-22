//
//  PopUpViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

final class PopUpViewController: UIViewController {

    public var goalResponse: GoalResponse? {
        didSet {
            guard let response = goalResponse else {return}
            nameLabel.text = response.name
            characterImageView.image = Snowe(rawValue: response.type)?.getImage(level: response.level)
            goalLabel.text = response.objective
        }
    }

    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.makeRound(16)
    }

    private let titleLabel = UILabel().then {
        $0.font = .spoqa(size: 20, family: .bold)
        $0.text = "눈덩이 생성 완료!"
    }

    private let characterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let nameLabel = UILabel().then {
        $0.font = .spoqa(size: 18, family: .medium)
    }

    private let goalLabel = UILabel().then {
        $0.font = .spoqa(size: 16, family: .regular)
    }

    private lazy var okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = .spoqa(size: 18, family: .bold)

        $0.makeRound()

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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
}

extension PopUpViewController {
    @objc
    public func buttonDidTapped(_ sender: UIButton) {
        guard let pvc = self.presentingViewController else { return }
        dismiss(animated: true) {
            pvc.dismiss(animated: true, completion: nil)
        }
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
            goalLabel,
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

        goalLabel.snp.makeConstraints {
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
