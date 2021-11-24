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
            self.goals = response.goals
            self.goalsCount = response.goalCount
            self.tableView.reloadData()
        }
    }

    private var goals: [GoalResponse?] = []

    private var goalsCount = 0 {
        didSet {
            tableView.isHidden = goalsCount == 0
            noCharacterLabel.isHidden = goalsCount > 0
        }
    }

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
                    goalText: goal.name,
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
    }
}

extension DeleteCharacterViewController {
    func getGoals() {
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
