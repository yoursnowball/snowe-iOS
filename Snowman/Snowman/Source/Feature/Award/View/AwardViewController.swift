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
        return 121
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
        if let characterType = CharacterType(rawValue: awards[indexPath.row].type) {
            cell.updateData(
                with: characterType,
                goalText: awards[indexPath.row].name,
                nameText: awards[indexPath.row].name,
                level: awards[indexPath.row].level
            )
            return cell
        } else {
            return UITableViewCell()
        }
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
        view.addSubviews(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        headerView.addSubviews(headerTitleLabel)
        headerView.snp.makeConstraints {
            $0.height.equalTo(77)
        }
        headerTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(18)
        }
    }
}
