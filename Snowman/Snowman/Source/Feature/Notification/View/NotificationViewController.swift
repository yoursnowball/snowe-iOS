//
//  NotificationViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/22.
//

import UIKit

import SnapKit
import Then

final class NotificationViewController: BaseViewController {

    private let data: [NotificationResponse] = [
        NotificationResponse(title: "[눈덩이이름] 진화 완료!", content: "축하합니다🎉 [눈덩이이름]이 진화했어요!", time: "n분 전"),
        NotificationResponse(title: "[눈덩이이름] 진화 완료!", content: "서두르세요!\n오늘의 투두 완료시간이 얼마 남지 않았어요!", time: "n분 전"),
        NotificationResponse(title: "[눈덩이이름] 진화 완료!", content: "축하합니다🎉 [눈덩이이름]이 진화했어요!", time: "n분 전")
    ]

    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.registerReusableCell(NotificationTableViewCell.self)
        $0.rowHeight = UITableView.automaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }

}

extension NotificationViewController: UITableViewDelegate {

}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.updateData(notificationResponse: data[indexPath.row])
        return cell
    }
}

extension NotificationViewController {
    private func setLayouts() {
        view.addSubviews(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}
