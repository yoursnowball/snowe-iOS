//
//  GoalQuestionViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

final class GoalQuestionViewController: QuestionBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
        setDelegation()
    }

    override func nextButtonDidTapped(_ sender: UIButton) {
        goToNextViewController()
    }

}

extension GoalQuestionViewController {
    private func setDelegation() {
        textFieldDelegate = self
    }

    private func setProperties() {
        numberLabelText = "1/3"
        questionLabelText = "당신의 목표는 무엇인가요?"
        descriptionLabelText = "목표"
        textFieldTextCount = 15
    }

    private func goToNextViewController() {
        navigationController?.pushViewController(CharacterChoiceViewController(), animated: true)
    }
}
extension GoalQuestionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            goToNextViewController()
            return true
        } else {
            return false
        }
    }
}
