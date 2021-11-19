//
//  AwardViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

final class AwardViewController: BaseViewController {

    private let headerView = UIView()

    private let headerTitleLabel = UILabel().then {
        $0.font = .spoqa(size: 22, family: .medium)
        $0.text = "총 3개의 눈사람을 만들었어요"
    }

    private lazy var tableView = UITableView().then {
        $0.registerReusableCell(AwardTableViewCell.self)
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
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
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AwardTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.updateData(
            with: .red.withAlphaComponent(0.1),
            goalText: "900점 달성하고 놀러가기",
            nameText: "수줍은눈사람",
            characterImageName: "person.fill"
        )
        return cell
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
