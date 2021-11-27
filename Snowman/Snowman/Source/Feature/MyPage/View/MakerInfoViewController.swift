//
//  MakerInfoViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/25.
//

import UIKit

final class MakerInfoViewController: BaseViewController {
    private lazy var headerView = MakerInfoHeaderView()

    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
        $0.registerReusableCell(MyPageContentTableViewCell.self)
        $0.tableHeaderView = headerView
        $0.tableHeaderView?.frame.size.height = 240
    }

    private let datasource = [
        ["김용현", "김윤서", "김태준"],
        ["김주현", "이시은"]
    ]

    private let linkDatasource = [
        [
            "https://github.com/lygon55555",
            "https://github.com/ezidayzi",
            "https://github.com/ktj1997"
        ],
        [
            "https://decorous-turquoise-af1.notion.site/bd3b9d5b6c9643bfb936c14c5061a9c8",
            "https://www.notion.so/joeum/0370e5a5de8f461da434a8a8e91279a9"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ViewTitle.makerInfo
        setLayouts()
    }
}

extension MakerInfoViewController: UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MyPageSectionHeaderView()
        switch section {
        case 0:
            header.setTitleText(title: "⚙️Developer")
        case 1:
            header.setTitleText(title: "🎨Designer")
        default:
            break
        }

        return header
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 9
        default:
            return 0
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let url = URL(string: linkDatasource[indexPath.section][indexPath.row]) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension MakerInfoViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyPageContentTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.setTitle(title: datasource[indexPath.section][indexPath.row], isOnlyTitle: true)
        return cell
    }
}

extension MakerInfoViewController {
    private func setLayouts() {
        setViewHierarchy()
        setConstraints()
    }

    private func setViewHierarchy() {
        view.addSubviews(tableView)
    }

    private func setConstraints() {
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}
