//
//  RankViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

import UIKit

final class RankViewController: BaseViewController {

    private var ranks: RankResponse? {
        didSet {
            guard let ranks = ranks else {
                return
            }
            nextPage = ranks.currentPage + 1
            isLast = ranks.isLast
        }
    }

    private var rankInfos: [RankUserInfo] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var nextPage: Int = 0
    var isLast: Bool = false

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRank(page: nextPage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }

}

extension RankViewController {
    private func getRank(page: Int) {
        if !isLast {
            NetworkService.shared.award.getRank(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let data = response as? RankResponse else { return }
                    self?.ranks = data
                    self?.rankInfos.append(contentsOf: data.content)
                case .requestErr(let errorResponse):
                    dump(errorResponse)
                default:
                    print("error")
                }
            }
        }
    }
}

extension RankViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
         if (indexPath.row == rankInfos.count - 1 ) {
             getRank(page: nextPage)
         }
    }
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

extension RankViewController {
    private func render() {
        view.addSubviews(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}
