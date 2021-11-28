//
//  AwardViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

final class AwardViewController: BaseViewController {

    private var awards: [Award] = [] {
        didSet {
            headerTitleLabel.text = "총 \(awards.count)개의 눈사람을 만들었어요"
            noCharacterLabel.isHidden = awards.count != 0
            tableView.isHidden = awards.count == 0
        }
    }

    private let headerView = UIView()

    private let headerTitleLabel = UILabel().then {
        $0.font = .spoqa(size: 22, family: .medium)
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
            명예의 전당에 등록된
            눈사람이 없어요😥
            """
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = .lightGray
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAwards()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }

}

extension AwardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
}

extension AwardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return awards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AwardTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        if let characterType = Snowe(rawValue: awards[indexPath.row].type) {
            cell.updateAwardData(
                with: characterType,
                goalText: awards[indexPath.row].objective,
                nameText: awards[indexPath.row].name,
                level: awards[indexPath.row].level,
                goalId: awards[indexPath.row].id,
                awardAt: awards[indexPath.row].awardAt
            )
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: AwardTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        let vc = HistoryViewController()
        vc.goalId = cell.goalId
        vc.awardAt = cell.awardAt
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension AwardViewController {
    func getAwards() {
        NetworkService.shared.award.getAwards {[weak self] result in
            switch result {
            case .success(let response):
                guard let data = response as? AwardsResponse else { return }
                self?.awards = data.awards
                self?.tableView.reloadData()
            case .requestErr(let errorResponse):
                dump(errorResponse)
            default:
                print("error")
            }
        }
    }
}

extension AwardViewController {
    private func setLayouts() {
        view.addSubviews(
            tableView,
            noCharacterLabel
        )
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        noCharacterLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
        }

        headerView.addSubviews(headerTitleLabel)
        headerView.snp.makeConstraints {
            $0.height.equalTo(72)
        }
        
        headerTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(18)
        }
    }
}
