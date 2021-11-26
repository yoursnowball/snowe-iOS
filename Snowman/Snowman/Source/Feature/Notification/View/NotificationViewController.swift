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

    var nextPage: Int = 0
    var isLast: Bool = false

    private var data: GenericPageArrayResponse<AlarmResponse>? {
        didSet {
            guard let data = data else {
                return
            }
            alarms.append(contentsOf: data.content)
            nextPage = data.currentPage + 1
            isLast = data.isLast
        }
    }

    private var alarms: [AlarmResponse] = [] {
        didSet {
            noAlarmsLabel.isHidden = alarms.count != 0
            tableView.reloadData()
        }
    }

    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.registerReusableCell(NotificationTableViewCell.self)
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
    }

    private let noAlarmsLabel = UILabel().then {
        $0.text = """
            아직까지는 온 알림이 없어요!
            있으면 여기서 알려드릴게요 🔔
            """
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = .lightGray
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAlarmList(page: nextPage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alert"
        setLayouts()
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == alarms.count - 1 {
            getAlarmList(page: nextPage)
        }
    }
}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.updateData(response: alarms[indexPath.row])
        return cell
    }
}

extension NotificationViewController {
    private func getAlarmList(page: Int) {
        if !isLast {
            NetworkService.shared.user.getAlarmList(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let data = response as? GenericPageArrayResponse<AlarmResponse> else { return }
                    self?.data = data
                case .requestErr(let errorResponse):
                    dump(errorResponse)
                default:
                    print("error")
                }
            }
        }
    }
}

extension NotificationViewController {
    private func setLayouts() {
        view.addSubviews(tableView, noAlarmsLabel)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }

        noAlarmsLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
