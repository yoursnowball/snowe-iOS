//
//  AwardViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

final class AwardViewController: BaseViewController {

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
    }
}
