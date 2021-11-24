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
    }

    private let datasource = [
        ["캐릭터 삭제", "로그아웃"],
        ["제작자들"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "마이페이지"
        setLayouts()
    }
}

extension MyPageViewController: UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MyPageSectionHeaderView()
        switch section {
        case 0:
            header.setTitleText(title: "My")
        case 1:
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

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 9
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        let seperator = UIView()
        footer.addSubviews(seperator)
        seperator.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        seperator.backgroundColor = Color.Gray300
        return footer
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                navigationController?.pushViewController(DeleteCharacterViewController(), animated: true)
            case 1:
                let defaults = UserDefaults.standard
                let dictionary = defaults.dictionaryRepresentation()
                dictionary.keys.forEach { key in
                    defaults.removeObject(forKey: key)
                }
                RootViewControllerChanger.updateRootViewController()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                let view = MakerInfoViewController()
                navigationController?.pushViewController(view, animated: true)
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
        return datasource[section].count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyPageContentTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.setTitle(title: datasource[indexPath.section][indexPath.row], isOnlyTitle: true)
        return cell
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
