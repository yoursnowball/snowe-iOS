//
//  LoginViewController.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import SnapKit
import UIKit

class SignInViewController: BaseViewController {
    var isButtonStatusChange: Bool = false {
        didSet {
            if isButtonStatusChange {
                signInButton.setBackgroundColor(Color.button_blue, for: .normal)
                signInButton.isEnabled = true
                idTextField.returnKeyType = .done
                passwordTextField.returnKeyType = .done
                idTextField.reloadInputViews()
                passwordTextField.reloadInputViews()
            } else {
                signInButton.setBackgroundColor(Color.Gray500, for: .normal)
                signInButton.isEnabled = false
                idTextField.returnKeyType = .default
                passwordTextField.returnKeyType = .default
                idTextField.reloadInputViews()
                passwordTextField.reloadInputViews()
            }
        }
    }

    let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = Color.text_Primary
        $0.sizeToFit()
    }

    let idTextField = UITextField()

    let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = Color.text_Primary
        $0.sizeToFit()
    }

    let passwordTextField = UITextField()

    let signInButton = UIButton(type: .system).then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = .spoqa(size: 18, family: .regular)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setBackgroundColor(Color.Gray500, for: .normal)
        $0.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ViewTitle.login
        setIdTextField()
        setPasswordTextField()
        setLayouts()
        registerTarget()
    }

    private func registerTarget() {
        [signInButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapAction(_:)), for: .touchUpInside)
        }
    }

    @objc
    private func buttonTapAction(_ sender: UIButton) {
        switch sender {
        case signInButton:
            signIn()
        default:
            return
        }
    }

    @objc private func doneButtonDidTap() {
        idTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @objc private func focusToOverButtonDidTap() {
        passwordTextField.resignFirstResponder()
        idTextField.becomeFirstResponder()
    }

    @objc private func focusToUnderButtonDidTap() {
        idTextField.resignFirstResponder()
        passwordTextField.becomeFirstResponder()
    }

    func signIn() {
        guard let userName = self.idTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }

        postSignIn(password: password, userName: userName) { data in
            UserDefaults.standard.setValue(true, forKey: UserDefaultKey.loginStatus)
            UserDefaults.standard.setValue(data.token, forKey: UserDefaultKey.token)
            UserDefaults.standard.synchronize()

            RootViewControllerChanger.updateRootViewController()
        }
    }

    func postSignIn(password: String, userName: String, completion: @escaping (AuthResponse) -> Void) {
        NetworkService.shared.auth.postSignIn(password: password, userName: userName) { result in
            switch result {
            case .success(let response):
                guard let data = response as? AuthResponse else { return }
                completion(data)
            case .requestErr(let errorResponse):
                dump(errorResponse)
                guard let data = errorResponse as? ErrorResponse else { return }
                self.showToastMessageAlert(message: data.message)
            default:
                print("sign in error")
            }
        }
    }

    func showToastMessageAlert(message: String) {
        let alert = UIAlertController(title: message,
                                      message: "",
                                      preferredStyle: .alert)

        present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            alert.dismiss(animated: true)
        }
    }

    func setIdTextField() {
        idTextField.placeholder = "아이디"
        idTextField.delegate = self
        idTextField.backgroundColor = Color.Gray100
        idTextField.clipsToBounds = true
        idTextField.layer.cornerRadius = 8
        idTextField.clearButtonMode = .never
        idTextField.keyboardType = .alphabet
        idTextField.addLeftPadding()
        idTextField.layer.borderWidth = 0
        idTextField.autocapitalizationType = .none
        idTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        idTextField.becomeFirstResponder()
    }

    func setPasswordTextField() {
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.delegate = self
        passwordTextField.backgroundColor = Color.Gray100
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.clearButtonMode = .never
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.addLeftPadding()
        passwordTextField.layer.borderWidth = 0
        passwordTextField.autocapitalizationType = .none
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange() {
        if idTextField.text != "", passwordTextField.text != "" {
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

    func setLayouts() {
        view.addSubviews(idLabel,
                         idTextField,
                         passwordLabel,
                         passwordTextField,
                         signInButton)

        let guide = view.safeAreaLayoutGuide

        idLabel.snp.makeConstraints {
            $0.top.equalTo(guide).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(41)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(53)
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            buttonTapAction(_: signInButton)
            return true
        } else {
            textField.resignFirstResponder()
            if textField == idTextField {
                passwordTextField.becomeFirstResponder()
            } else if textField == passwordTextField {
                idTextField.becomeFirstResponder()
            } else {
                return false
            }
            return true
        }
    }
}
