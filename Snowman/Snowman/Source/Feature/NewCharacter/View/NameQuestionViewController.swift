//
//  NameQuestionViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

final class NameQuestionViewController: QuestionBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
        makeCloseButton()
    }

    override func nextButtonDidTapped(_ sender: UIButton) {
        goToNextViewController()
    }

    override func textFieldDidChange(_ textField: UITextField) {
        super.textFieldDidChange(textField)
        NewGoal.shared.objective = textField.text
    }
}

extension NameQuestionViewController {
    private func setProperties() {
        numberLabelText = "3/3"
        questionLabelText = "눈덩이의 이름을 알려주세요"
        descriptionLabelText = "이름"
        textFieldTextCount = 8
    }

    private func goToNextViewController() {
        postNewCharacter { [weak self] response in
            self?.hideButton()
            let popUpView = PopUpViewController()
            popUpView.goalResponse = response
            popUpView.modalPresentationStyle = .overCurrentContext
            popUpView.modalTransitionStyle = .crossDissolve
            self?.present(popUpView, animated: true, completion: nil)
        }
    }
}

extension NameQuestionViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            goToNextViewController()
            return true
        } else {
            return false
        }
    }
}

extension NameQuestionViewController {
    func postNewCharacter(completion: @escaping (GoalResponse) -> Void) {
        guard let newGoal = NewGoal.shared.makeNewGoal() else { return }
        NetworkService.shared.goal.postNewGoal(
            name: newGoal.name,
            type: newGoal.type,
            objective: newGoal.objective
        ) { result in
            switch result {
            case .success(let response):
                guard let data = response as? GoalResponse else { return }
                NotificationCenter.default.post(name: .refreshHomeVC, object: nil)
                completion(data)
            case .requestErr(let errorResponse):
                dump(errorResponse)
            default:
                print("error")
            }
        }
    }
}


