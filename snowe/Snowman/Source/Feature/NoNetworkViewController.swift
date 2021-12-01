//
//  NoNetworkViewController.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/28.
//

import UIKit
import SnapKit
import Then

class NoNetworkViewController: UIViewController {
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "60_networkerror_sad_icon")
    }

    let noConnectionLabel = UILabel().then {
        $0.text = """
            인터넷에
            연결되지 않았어요
            """
        $0.font = UIFont.spoqa(size: 24, family: .bold)
        $0.textColor = Color.text_Primary
    }

    let retryLabel = UILabel().then {
        $0.text  = "연결 확인 후 다시 시도해주세요"
        $0.font = UIFont.spoqa(size: 14, family: .regular)
        $0.sizeToFit()
        $0.textColor = Color.text_Primary
    }

    let retryButton = UIButton().then {
        $0.titleLabel?.font = UIFont.spoqa(size: 14, family: .bold)
        $0.setTitleColor(Color.Gray000, for: .normal)
        $0.setTitle("새로고침", for: .normal)
        $0.backgroundColor = Color.button_blue
        $0.layer.cornerRadius = 10
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        registerTarget()
    }

    func setLayout() {
        self.view.addSubviews(
            imageView,
            noConnectionLabel,
            retryLabel,
            retryButton)

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(232)
            $0.leading.trailing.equalToSuperview().inset(157)
            $0.height.equalTo(imageView.snp.width)
        }

        noConnectionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(94)
            $0.top.equalTo(imageView.snp.bottom).offset(24)
        }

        retryLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(95)
            $0.top.equalTo(noConnectionLabel.snp.bottom).offset(8)
        }

        retryButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(123)
            $0.top.equalTo(retryLabel.snp.bottom).offset(24)
            $0.height.equalTo(32)
        }
    }

    private func registerTarget() {
        [retryButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapAction(_:)), for: .touchUpInside)
        }
    }

    @objc
    private func buttonTapAction(_ sender: UIButton) {
        switch sender {
        case retryButton:
            if !InternetConnectivity.isConnectedToInternet {
                showToastMessageAlert(message: "네트워크에 연결되지 않았습니다")
            } else {
                RootViewControllerChanger.updateRootViewController()
            }
        default:
            return
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
}
