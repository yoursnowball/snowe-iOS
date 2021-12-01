//
//  StartSignInViewController.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import SnapKit
import UIKit

class StartSignInViewController: BaseViewController {

    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "snoweLogo")
    }

    let signInButton = UIButton(type: .system).then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.spoqa(size: 18, family: .bold)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setBackgroundColor(Color.button_blue, for: .normal)
        $0.addTarget(self, action: #selector(signInTap), for: .touchUpInside)
    }

    let signUpButton = UIButton(type: .system).then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(Color.button_blue, for: .normal)
        $0.titleLabel?.font = UIFont.spoqa(size: 18, family: .bold)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setBackgroundColor(UIColor.white, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Color.button_blue.cgColor
        $0.addTarget(self, action: #selector(signUpTap), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setStructure()
        setConstraints()
    }

    @objc private func signInTap() {
        let viewController = SignInViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func signUpTap() {
        let viewController = SignUpNameIdViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func setStructure() {
        view.addSubviews(logoImageView,
                         signInButton,
                         signUpButton)
    }

    func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(172)
            make.height.equalTo(41)
        }

        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-34)
            make.height.equalTo(53)
        }

        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(signUpButton.snp.top).offset(-16)
            make.height.equalTo(53)
        }
    }
}
