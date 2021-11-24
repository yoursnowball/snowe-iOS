//
//  PopUpViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/25.
//

import UIKit

protocol PopUpActionDelegate: AnyObject {
//    func touchLeftButton(button: UIButton)// 추후 필요해지면 정의
    func touchRightButton(button: UIButton)
}

/// 팝업 타이틀, 왼쪽과 오른쪽 버튼의 텍스트와 오른쪽 action 을 지정해주세요
final class PopUpViewController: UIViewController {

    weak var delegate: PopUpActionDelegate?

    private let popUpView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.makeRound(20)
    }

    private lazy var leftButton = UIButton(type: .system).then {
        $0.titleLabel?.font = .spoqa(size: 14, family: .regular)
        $0.setTitleColor(Color.text_Primary, for: .normal)
        $0.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
    }

    private lazy var rightButton = UIButton(type: .system).then {
        $0.titleLabel?.font = .spoqa(size: 14, family: .regular)
        $0.setBackgroundColor(Color.button_blue, for: .normal)
        $0.makeRound(18)
        $0.setTitleColor(Color.text_Primary, for: .normal)
        $0.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
    }

    private let titleLabel = UILabel().then {
        $0.textColor = Color.text_Primary
        $0.font = .spoqa(size: 14, family: .bold)
        $0.textAlignment = .center
    }

    private let contentLabel = UILabel().then {
        $0.textColor = Color.text_Primary
        $0.font = .spoqa(size: 14, family: .regular)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillProportionally
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeDimBackground()
        render()
    }

    private func makeDimBackground() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }

    public func setText(
        title: String?,
        content: String,
        leftButtonText: String? = "취소",
        rightButtonText: String
    ) {
        titleLabel.text = title
        contentLabel.text = content
        leftButton.setTitle(leftButtonText, for: .normal)
        rightButton.setTitle(rightButtonText, for: .normal)
    }
}

extension PopUpViewController {
    @objc
    private func buttonDidTapped(_ sender: UIButton) {
        switch sender {
        case leftButton:
            dismiss(animated: true, completion: nil)
        case rightButton:
            delegate?.touchRightButton(button: sender)
        default:
            break
        }
    }
}

extension PopUpViewController {
    private func render() {
        view.addSubviews(popUpView)
        labelStackView.addArrangedSubviews(titleLabel, contentLabel)
        buttonStackView.addArrangedSubviews(leftButton, rightButton)
        popUpView.addSubviews(labelStackView, buttonStackView)

        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(53)
        }

        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(80)
        }

        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
    }
}
