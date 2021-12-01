//
//  SignUpNameIdViewController.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import SnapKit
import UIKit

class SignUpNameIdViewController: BaseViewController {
    var isButtonStatusChange: Bool = false {
        didSet {
            if isButtonStatusChange {
                nextButton.setBackgroundColor(Color.button_blue, for: .normal)
                nextButton.isEnabled = true
                nicknameTextField.returnKeyType = .done
                idTextField.returnKeyType = .done
                nicknameTextField.reloadInputViews()
                idTextField.reloadInputViews()
            } else {
                nextButton.setBackgroundColor(Color.Gray500, for: .normal)
                nextButton.isEnabled = false
                nicknameTextField.returnKeyType = .default
                idTextField.returnKeyType = .default
                nicknameTextField.reloadInputViews()
                idTextField.reloadInputViews()
            }
        }
    }

    let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = Color.text_Primary
        $0.sizeToFit()
    }

    let nicknameTextField = UITextField()

    let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = Color.text_Primary
        $0.sizeToFit()
    }

    let idTextField = UITextField()

    let nextButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = .spoqa(size: 18, family: .regular)
        $0.setBackgroundColor(Color.Gray500, for: .normal)
        $0.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ViewTitle.signUp
        setNameTextField()
        setIdTextField()
        setLayouts()
        registerTarget()
        registerForKeyboardNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nicknameTextField.becomeFirstResponder()
    }

    private func registerTarget() {
        [nextButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapAction(_:)), for: .touchUpInside)
        }
    }

    @objc
    private func buttonTapAction(_ sender: UIButton) {
        switch sender {
        case nextButton:
            goToNextVC()
        default:
            return
        }
    }

    @objc private func doneButtonDidTap() {
        nicknameTextField.resignFirstResponder()
        idTextField.resignFirstResponder()
    }

    @objc private func focusToOverButtonDidTap() {
        idTextField.resignFirstResponder()
        nicknameTextField.becomeFirstResponder()
    }

    @objc private func focusToUnderButtonDidTap() {
        nicknameTextField.resignFirstResponder()
        idTextField.becomeFirstResponder()
    }

    func goToNextVC() {
        let viewController = SignUpPasswordViewController()
        viewController.nickname = nicknameTextField.text
        viewController.id = idTextField.text

        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func setNameTextField() {
        nicknameTextField.placeholder = "닉네임"
        nicknameTextField.delegate = self
        nicknameTextField.backgroundColor = Color.Gray100
        nicknameTextField.clipsToBounds = true
        nicknameTextField.layer.cornerRadius = 8
        nicknameTextField.clearButtonMode = .never
        nicknameTextField.addLeftPadding()
        nicknameTextField.layer.borderWidth = 0
        nicknameTextField.autocapitalizationType = .none
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    func setIdTextField() {
        idTextField.placeholder = "아이디"
        idTextField.delegate = self
        idTextField.backgroundColor = Color.Gray100
        idTextField.clipsToBounds = true
        idTextField.layer.cornerRadius = 8
        idTextField.clearButtonMode = .never
        idTextField.keyboardType = .asciiCapable
        idTextField.addLeftPadding()
        idTextField.layer.borderWidth = 0
        idTextField.autocapitalizationType = .none
        idTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange() {
        if nicknameTextField.text != "", idTextField.text != "" {
            if isButtonStatusChange == true {
                return
            } else {
                isButtonStatusChange = true
            }
        } else {
            if isButtonStatusChange == false {
                return
            } else {
                isButtonStatusChange = false
            }
        }
    }

    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustView),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    @objc private func adjustView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (
            userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue else { return }

        let adjustmentHeight = keyboardFrame.height

        nextButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-adjustmentHeight)
        }
    }

    func setLayouts() {
        view.addSubviews(nicknameLabel,
                         nicknameTextField,
                         idLabel,
                         idTextField,
                         nextButton)

        let guide = view.safeAreaLayoutGuide

        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(guide).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        idLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }

        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
}

extension SignUpNameIdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            buttonTapAction(_: nextButton)
            return true
        } else {
            textField.resignFirstResponder()
            if textField == nicknameTextField {
                idTextField.becomeFirstResponder()
            } else if textField == idTextField {
                nicknameTextField.becomeFirstResponder()
            } else {
                return false
            }
            return true
        }
    }
}
