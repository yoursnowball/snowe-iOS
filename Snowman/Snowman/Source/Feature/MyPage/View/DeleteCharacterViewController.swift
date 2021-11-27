//
//  DeleteCharacterViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/25.
//

import UIKit

class DeleteCharacterViewController: BaseViewController {

    private var userResponse: UserResponse? {
        didSet {
            guard let response = userResponse else { return }
            goals = response.goals
            goalsCount = response.goalCount
            tableView.reloadData()
            noCharacterLabel.isHidden = response.goalCount != 0
        }
    }

    private var goals: [GoalResponse?] = []

    private var goalsCount = 0 {
        didSet {
            tableView.isHidden = goalsCount == 0
            noCharacterLabel.isHidden = goalsCount > 0
        }
    }

    private var selectedIndex = 0

    private lazy var tableView = UITableView().then {
        $0.registerReusableCell(AwardTableViewCell.self)
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.allowsSelection = true
    }

    private let noCharacterLabel = UILabel().then {
        $0.text = """
                아직 등록된 눈사람이 없어요!
                눈덩이를 생성해보세요😃
                """
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = .lightGray
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGoals()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "캐릭터 삭제"
        setLayouts()
    }

}

extension DeleteCharacterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }

}

extension DeleteCharacterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AwardTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.selectionStyle = .none
        if let goal = goals[indexPath.row] {
            if let characterType = Snowe(rawValue: goal.type) {
                cell.updateMyPageData(
                    with: characterType,
                    goalText: goal.objective,
                    nameText: goal.name,
                    level: goal.level,
                    goalId: goal.id
                )
                return cell
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        let popUpView = PopUpViewController()
        popUpView.modalTransitionStyle = .crossDissolve
        popUpView.modalPresentationStyle = .overCurrentContext
        popUpView.delegate = self
        popUpView.setText(
            title: "삭제하시겠어요?",
            content: "캐릭터를 삭제하면\n더 이상 복구할 수 없어요.",
            rightButtonText: "삭제"
        )
        present(popUpView, animated: true, completion: nil)
    }
}

extension DeleteCharacterViewController {
    private func getGoals() {
        NetworkService.shared.user.getUsers {[weak self] result in
            switch result {
            case .success(let response):
                guard let data = response as? UserResponse else { return }
                self?.userResponse = data
            case .requestErr(let errorResponse):
                dump(errorResponse)
            default:
                print("error")
            }
        }
    }

    private func deleteGoal(goalId: Int) {
        NetworkService.shared.goal.deleteGoal(goalId: goalId) {[weak self] result in
            switch result {
            case 200..<300:
                self?.getGoals()
                self?.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
}

extension DeleteCharacterViewController: PopUpActionDelegate {
    func touchRightButton(button: UIButton) {
        guard let goal = goals[selectedIndex] else { return }
        deleteGoal(goalId: goal.id)
    }
}

extension DeleteCharacterViewController {
    private func setLayouts() {
        view.addSubviews(
            tableView,
            noCharacterLabel
        )

        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }

        noCharacterLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
        }
    }
}
