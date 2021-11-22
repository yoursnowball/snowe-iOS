//
//  SignUpPasswordViewController.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import SnapKit
import UIKit

class SignUpPasswordViewController: UIViewController {
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
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setBackgroundColor(UIColor.gray, for: .normal)
        $0.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavBar()
        setIdTextField()
        setPasswordTextField()
        setLayouts()
        registerTarget()
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
//            sendSignUpData()
        break
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

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    private func setNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "회원가입"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    
    
//    func sendSignUpData() {
//        if let email = idTextField.text,
//           let password = passwordTextField.text {
//            let param = [
//                "email": "\(email + "@soongsil.ac.kr")",
//                "password": password,
//            ]
//
//            Alamofire.request(URLModel.signInApiUrlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
//                .responseJSON { response in
//                    switch response.result {
//                    case let .success(value):
//                        do {
//                            if let statusCode = response.response?.statusCode {
//                                let json = SwiftyJSON.JSON(value)
//                                if statusCode >= 200, statusCode < 300 {
//                                    guard let accessTokenExpiredIn = json["accessTokenExpiredIn"].int,
//                                          let refreshTokenExpiredIn = json["refreshTokenExpiredIn"].int
//                                    else {
//                                        self.showAlert(title: nil, message: "만료 시간이 잘못 설정됨", isCompleted: true)
//                                        return
//                                    }
//
//                                    let accessToken = AccessToken(json["accessToken"].stringValue, expiredIn: accessTokenExpiredIn)
//                                    let refreshToken = RefreshToken(json["refreshToken"].stringValue, expiredIn: refreshTokenExpiredIn)
//
//                                    AuthData.accessToken = accessToken
//                                    AuthData.refreshToken = refreshToken
//
//                                    AuthData.userId = email
//
//                                    UserDefaults.standard.setValue(email, forKey: UserDefaultKey.userId)
//
//                                    self.showAutoSignInAlert(title: "자동 로그인 활성화", message: "자동 로그인을 활성화 하시겠습니까?")
//                                } else if json["error"].stringValue == "Auth-005" {
//                                    self.showAlert(title: "로그인에 실패하였습니다.", message: "학교 메일 혹은 비밀번호가\n 일치하지 않습니다.", isCompleted: false)
//                                } else {
//                                    self.showAlert(title: nil, message: "\(json["message"].stringValue)", isCompleted: true)
//                                }
//                            }
//                        }
//                    case let .failure(err):
//                        self.showAlert(title: nil, message: "네트워크 오류가 발생했습니다.", isCompleted: true)
//                        print(err.localizedDescription)
//                    }
//                }
//        }
//    }
    
    
    

    func setIdTextField() {
        passwordTextField.placeholder = "아이디"
        passwordTextField.delegate = self
        passwordTextField.backgroundColor = UIColor.lightGray
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.clearButtonMode = .never
        passwordTextField.keyboardType = .alphabet
        passwordTextField.addLeftPadding()
        passwordTextField.layer.borderWidth = 0
        passwordTextField.autocapitalizationType = .none
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    func setPasswordTextField() {
        passwordCheckTextField.placeholder = "비밀번호"
        passwordCheckTextField.delegate = self
        passwordCheckTextField.backgroundColor = UIColor.lightGray
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

    func setLayouts() {
        view.addSubviews(passwordLabel,
                         passwordTextField,
                         passwordCheckLabel,
                         passwordCheckTextField,
                         signUpButton)

        passwordLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
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
            $0.top.equalTo(passwordCheckTextField.snp.bottom).offset(41)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(53)
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
