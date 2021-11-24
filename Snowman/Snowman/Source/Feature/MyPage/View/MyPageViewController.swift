//
//  MyPageViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/24.
//

import UIKit

final class MyPageViewController: BaseViewController {
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
        $0.registerReusableCell(MyPageContentTableViewCell.self)
        $0.registerReusableHeaderFooterView(MyPageSectionHeaderView.self)
    }

    private let accountTableContents: [String] = ["로그아웃"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Page"
        setLayouts()
    }
}

extension MyPageViewController: UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 3
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: MyPageSectionHeaderView = tableView.dequeueReusableHeaderFooterView()
        switch section {
        case 0:
            header.setTitleText(title: "목표")
        case 1:
            header.setTitleText(title: "계정")
        case 2:
            header.setTitleText(title: "앱 정보")
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

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                let defaults = UserDefaults.standard
                let dictionary = defaults.dictionaryRepresentation()
                dictionary.keys.forEach { key in
                    defaults.removeObject(forKey: key)
                }
                RootViewControllerChanger.updateRootViewController()
            default:
                break
            }
        default:
            break
        }
    }
}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return accountTableContents.count
        default:
            return 0
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell: MyPageContentTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.setTitle(title: accountTableContents[indexPath.row], isOnlyTitle: true)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MyPageViewController {
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
