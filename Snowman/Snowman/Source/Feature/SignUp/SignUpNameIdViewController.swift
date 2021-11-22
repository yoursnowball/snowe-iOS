//
//  SignUpNameIdViewController.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import SnapKit
import UIKit

class SignUpNameIdViewController: UIViewController {
    var isButtonStatusChange: Bool = false {
        didSet {
            if isButtonStatusChange {
                nextButton.setBackgroundColor(UIColor.blue, for: .normal)
                nextButton.isEnabled = true
                nameTextField.returnKeyType = .done
                idTextField.returnKeyType = .done
                nameTextField.reloadInputViews()
                idTextField.reloadInputViews()
            } else {
                nextButton.setBackgroundColor(UIColor.gray, for: .normal)
                nextButton.isEnabled = false
                nameTextField.returnKeyType = .default
                idTextField.returnKeyType = .default
                nameTextField.reloadInputViews()
                idTextField.reloadInputViews()
            }
        }
    }

    let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor.black
        $0.sizeToFit()
    }

    let nameTextField = UITextField()

    let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor.black
        $0.sizeToFit()
    }

    let idTextField = UITextField()

    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
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
        setNameTextField()
        setIdTextField()
        setLayouts()
        registerTarget()
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
        break
        default:
            return
        }
    }

    @objc private func doneButtonDidTap() {
        nameTextField.resignFirstResponder()
        idTextField.resignFirstResponder()
    }

    @objc private func focusToOverButtonDidTap() {
        idTextField.resignFirstResponder()
        nameTextField.becomeFirstResponder()
    }

    @objc private func focusToUnderButtonDidTap() {
        nameTextField.resignFirstResponder()
        idTextField.becomeFirstResponder()
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

    
    
    
    func goToNextVC() {
        // 이름, 아이디 넘기고
        // 다음 VC로 푸시
    }
    
    
    

    func setNameTextField() {
        nameTextField.placeholder = "이름"
        nameTextField.delegate = self
        nameTextField.backgroundColor = UIColor.lightGray
        nameTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 8
        nameTextField.clearButtonMode = .never
        nameTextField.keyboardType = .alphabet
        nameTextField.addLeftPadding()
        nameTextField.layer.borderWidth = 0
        nameTextField.autocapitalizationType = .none
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    func setIdTextField() {
        idTextField.placeholder = "아이디"
        idTextField.delegate = self
        idTextField.backgroundColor = UIColor.lightGray
        idTextField.isSecureTextEntry = true
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
        if nameTextField.text != "", idTextField.text != "" {
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
        view.addSubviews(nameLabel,
                         nameTextField,
                         idLabel,
                         idTextField,
                         nextButton)

        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        idLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }

        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        nextButton.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(41)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(53)
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
            if textField == nameTextField {
                idTextField.becomeFirstResponder()
            } else if textField == idTextField {
                nameTextField.becomeFirstResponder()
            } else {
                return false
            }
            return true
        }
    }
}
