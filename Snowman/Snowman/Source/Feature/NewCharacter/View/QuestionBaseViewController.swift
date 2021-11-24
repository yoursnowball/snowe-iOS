//
//  QuestionBaseViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/18.
//

import UIKit

import SnapKit
import Then

class QuestionBaseViewController: BaseViewController {

    public var numberLabelText: String = "" {
        didSet {
            numberLabel.text = numberLabelText
        }
    }

    public var questionLabelText: String = "" {
        didSet {
            questionLabel.text = questionLabelText
        }
    }

    public var descriptionLabelText: String = "" {
        didSet {
            descriptionLabel.text = descriptionLabelText
        }
    }

    public var textFieldTextCount: Int = 0 {
        didSet {
            textField.attributedPlaceholder = NSMutableAttributedString(
                string: "\(textFieldTextCount)자 이내로 입력해주세요",
                attributes: [
                    .kern: -0.32,
                    .font: UIFont.spoqa(size: 16, family: .regular),
                    .foregroundColor: Color.text_Teritary
                ]
            )
        }
    }

    public var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = textFieldDelegate
        }
    }

    private let numberLabel = UILabel().then {
        $0.font = .spoqa(size: 16, family: .bold)
    }

    private let questionLabel = UILabel().then {
        $0.font = .spoqa(size: 22, family: .medium)
    }

    private let descriptionLabel = UILabel().then {
        $0.font = .spoqa(size: 12, family: .regular)
        $0.textColor = Color.button_blue
    }

    public lazy var textField = UITextField().then {
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = Color.text_Primary
        $0.clearButtonMode = .whileEditing
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private let bottomLineView = UIView().then {
        $0.backgroundColor = .lightGray
    }

    private lazy var nextButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(Color.button_blue, for: .normal)
        $0.setBackgroundColor(Color.Gray500, for: .disabled)
        $0.titleLabel?.font = .spoqa(size: 18, family: .bold)
        $0.addTarget(self, action: #selector(nextButtonDidTapped(_:)), for: .touchUpInside)

        $0.snp.makeConstraints {
            $0.height.equalTo(53)
        }

        $0.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTextField()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
        registerNotification()
    }
}

extension QuestionBaseViewController {
    public func hideButton() {
        nextButton.isHidden = true
    }

    @objc
    public func nextButtonDidTapped(_ sender: UIButton) {}
}

extension QuestionBaseViewController {
    private func setTextField() {
        textField.becomeFirstResponder()
    }

    private func registerNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
}

extension QuestionBaseViewController {
    @objc
    private func showKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (
            userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue
        else { return }

        nextButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-keyboardFrame.height)
        }
    }

    @objc
    public func textFieldDidChange(_ textField: UITextField) {
        let textCount = textField.text?.count ?? 0
        nextButton.isEnabled = textCount > 0 && textCount < textFieldTextCount
        bottomLineView.backgroundColor = nextButton.isEnabled ?
            Color.button_blue : Color.text_Teritary
        textField.returnKeyType = nextButton.isEnabled ?
            .next : .default
        textField.reloadInputViews()
    }
}

extension QuestionBaseViewController {
    private func setLayouts() {
        setViewHierachies()
        setConstraints()
    }

    private func setViewHierachies() {
        view.addSubviews(
            numberLabel,
            questionLabel,
            descriptionLabel,
            textField,
            bottomLineView,
            nextButton
        )
    }

    private func setConstraints() {
        numberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(13)
            $0.height.equalTo(19)
        }

        questionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(numberLabel.snp.bottom).offset(8)
            $0.height.equalTo(26)
        }

        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(questionLabel.snp.bottom).offset(32)
            $0.height.equalTo(14)
        }

        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.height.equalTo(30)
        }

        bottomLineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(textField.snp.bottom).offset(4)
            $0.height.equalTo(1)
        }

        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

    }
}
