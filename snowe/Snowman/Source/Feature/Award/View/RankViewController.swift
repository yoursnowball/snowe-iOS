//
//  RankViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

import UIKit

final class RankViewController: BaseViewController {

    var nextPage: Int = 0
    var isLast: Bool = false

    private var data: GenericPageArrayResponse<RankInfoResponse>? {
        didSet {
            guard let data = data else {
                return
            }
            rankInfos.append(contentsOf: data.content)
            nextPage = data.currentPage + 1
            isLast = data.isLast
        }
    }

    private var rankInfos: [RankInfoResponse] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

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
//        getRank(page: nextPage)

        rankInfos.append(RankInfoResponse(awardAt: "", createdAt: "", id: 0, level: 7,
                                          name: "예비 공무원", objective: "7급 공무원 시험 합격하기", succeedTodoCount: 591, totalTodoCount: 700, type: "GREEN", userName: "스노위"))
        rankInfos.append(RankInfoResponse(awardAt: "", createdAt: "", id: 0, level: 6,
                                          name: "미래의 의사", objective: "국가 의사 고시 합격하기", succeedTodoCount: 321, totalTodoCount: 529, type: "PINK", userName: "스노우맨"))
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
                    guard let data = response as? GenericPageArrayResponse<RankInfoResponse> else { return }
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

extension RankViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
         if indexPath.row == rankInfos.count - 1 {
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
        return 16
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
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
