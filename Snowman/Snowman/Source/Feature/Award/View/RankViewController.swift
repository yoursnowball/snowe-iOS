//
//  RankViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

import UIKit

class RankViewController: BaseNavigationController {

    private var ranks: RankResponse?
    private var rankInfos: [RankUserInfo] = [
        RankUserInfo(awardAt: "", createdAt: "", id: 1, level: 10, name: "스노위하위", objective: "밥좀먹자", succeedTodoCount: 1000, totalTodoCount: 10000, type: "PINK", userName: "뮨서")
    ]

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(cell: RankCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }

}

extension RankViewController {
    private func render() {
        view.addSubviews(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}

extension RankViewController: UICollectionViewDelegate {

}

extension RankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rankInfos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: RankCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.updateData(rankUserInfo: rankInfos[indexPath.item], rank: indexPath.item + 1)
        return cell
    }

}

extension RankViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let width = UIScreen.main.bounds.width

        let cellWidth: CGFloat = width - 40
        let cellHeight: CGFloat = 90

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 33, left: 0, bottom: 33, right: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 14
    }
}
