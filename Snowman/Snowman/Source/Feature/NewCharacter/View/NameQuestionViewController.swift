//
//  NameQuestionViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

class NameQuestionViewController: QuestionBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
        setDelegation()
    }

    override func nextButtonDidTapped(_ sender: UIButton) {
        goToNextViewController()
    }
}

extension NameQuestionViewController {
    private func setDelegation() {
        textFieldDelegate = self
    }

    private func setProperties() {
        numberLabelText = "3/3"
        questionLabelText = "눈덩이의 이름을 알려주세요"
        descriptionLabelText = "이름"
        textFieldTextCount = 8
    }

    private func goToNextViewController() {
        let popUpView = PopUpViewController()
        popUpView.modalPresentationStyle = .overCurrentContext
        popUpView.modalTransitionStyle = .crossDissolve
        present(popUpView, animated: true, completion: nil)
    }
}
extension NameQuestionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            goToNextViewController()
            return true
        } else {
            return false
        }
    }
}
