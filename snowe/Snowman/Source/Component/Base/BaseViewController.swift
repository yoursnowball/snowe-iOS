//
//  BaseViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/18.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }

    private func render() {
        view.backgroundColor = .white
    }

    @objc
    private func closeButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController {
    public func makeCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self, action: #selector(closeButtonDidTapped)
        )
    }
}
