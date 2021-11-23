//
//  SignUpPasswordViewController.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import SnapKit
import UIKit

class SignUpPasswordViewController: UIViewController {

    var nickname: String!
    var id: String!

    var isButtonStatusChange: Bool = false {
        didSet {
            if isButtonStatusChange {
                signUpButton.setBackgroundColor(UIColor.blue, for: .normal)
                signUpButton.isEnabled = true
                passwordTextField.returnKeyType = .done
                passwordCheckTextField.returnKeyType = .done
                passwordTextField.reloadInputViews()
                passwordCheckTextField.reloadInputViews()
            } else {
                signUpButton.setBackgroundColor(UIColor.gray, for: .normal)
                signUpButton.isEnabled = false
                passwordTextField.returnKeyType = .default
                passwordCheckTextField.returnKeyType = .default
                passwordTextField.reloadInputViews()
                passwordCheckTextField.reloadInputViews()
            }
        }
    }

    let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor.black
        $0.sizeToFit()
    }

    let passwordTextField = UITextField()

    let passwordCheckLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor.black
        $0.sizeToFit()
    }

    let passwordCheckTextField = UITextField()

    let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.setBackgroundColor(UIColor.gray, for: .normal)
        $0.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        setNavBar()
        setIdTextField()
        setPasswordTextField()
        setLayouts()
        registerTarget()
        registerForKeyboardNotification()
    }

    private func registerTarget() {
        [signUpButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapAction(_:)), for: .touchUpInside)
        }
    }

    @objc
    private func buttonTapAction(_ sender: UIButton) {
        switch sender {
        case signUpButton:
            signUp()
        default:
            return
        }
    }

    @objc private func doneButtonDidTap() {
        passwordTextField.resignFirstResponder()
        passwordCheckTextField.resignFirstResponder()
    }

    @objc private func focusToOverButtonDidTap() {
        passwordCheckTextField.resignFirstResponder()
        passwordTextField.becomeFirstResponder()
    }

    @objc private func focusToUnderButtonDidTap() {
        passwordTextField.resignFirstResponder()
        passwordCheckTextField.becomeFirstResponder()
    }

    private func setNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "회원가입"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func signUp() {
        guard let nickName = self.nickname else { return }
        guard let userName = self.id else { return }
        guard let password = self.passwordTextField.text else { return }
        guard let passwordCheck = self.passwordCheckTextField.text else { return }

        if userName == password || userName == passwordCheck {
            showToastMessageAlert(message: "아이디, 비밀번호가 일치합니다. 다르게 입력해주세요.")
        } else if password != passwordCheck {
            showToastMessageAlert(message: "비밀번호가 일치하지 않습니다.")
        } else {
            postSignUp(nickName: nickName, password: password, userName: userName) { data in
                UserDefaults.standard.setValue(true, forKey: UserDefaultKey.loginStatus)
                UserDefaults.standard.setValue(data.token, forKey: UserDefaultKey.token)
                UserDefaults.standard.synchronize()

                self.showToastMessageAlert(message: "회원가입 완료!")
                RootViewControllerChanger.updateRootViewController()
            }
        }
    }

    func postSignUp(
        nickName: String,
        password: String,
        userName: String,
        completion: @escaping (AuthResponse) -> Void
    ) {
        NetworkService.shared.auth.postSignUp(nickName: nickName,
                                              password: password,
                                              userName: userName) { result in
            switch result {
            case .success(let response):
                guard let data = response as? AuthResponse else { return }
                completion(data)
            case .requestErr(let errorResponse):
                dump(errorResponse)
            default:
                print("sign up error")
            }
        }
    }

    func setIdTextField() {
        passwordTextField.placeholder = "아이디"
        passwordTextField.delegate = self
        passwordTextField.backgroundColor = UIColor.lightGray
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.clearButtonMode = .never
        passwordTextField.keyboardType = .alphabet
        passwordTextField.addLeftPadding()
        passwordTextField.layer.borderWidth = 0
        passwordTextField.autocapitalizationType = .none
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.becomeFirstResponder()
    }

    func setPasswordTextField() {
        passwordCheckTextField.placeholder = "비밀번호"
        passwordCheckTextField.delegate = self
        passwordCheckTextField.backgroundColor = UIColor.lightGray
        passwordCheckTextField.isSecureTextEntry = true
        passwordCheckTextField.isSecureTextEntry = true
        passwordCheckTextField.clipsToBounds = true
        passwordCheckTextField.layer.cornerRadius = 8
        passwordCheckTextField.clearButtonMode = .never
        passwordCheckTextField.keyboardType = .asciiCapable
        passwordCheckTextField.addLeftPadding()
        passwordCheckTextField.layer.borderWidth = 0
        passwordCheckTextField.autocapitalizationType = .none
        passwordCheckTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange() {
        if passwordTextField.text != "", passwordCheckTextField.text != "" {
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

        signUpButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-adjustmentHeight)
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

    func setLayouts() {
        view.addSubviews(passwordLabel,
                         passwordTextField,
                         passwordCheckLabel,
                         passwordCheckTextField,
                         signUpButton)

        let guide = view.safeAreaLayoutGuide

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(guide).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        passwordCheckLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }

        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordCheckLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        signUpButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
}

extension SignUpPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            buttonTapAction(_: signUpButton)
            return true
        } else {
            textField.resignFirstResponder()
            if textField == passwordTextField {
                passwordCheckTextField.becomeFirstResponder()
            } else if textField == passwordCheckTextField {
                passwordTextField.becomeFirstResponder()
            } else {
                return false
            }
            return true
        }
    }
}
