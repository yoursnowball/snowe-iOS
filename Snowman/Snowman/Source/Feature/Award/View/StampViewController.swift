//
//  StampViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/28.
//

import UIKit

import SnapKit
import Then

class StampViewController: UIViewController {

// MARK: - Properties

    private let headerView = UIView()

    private let headerTitleLabel = UILabel().then {
        $0.font = .spoqa(size: 22, family: .medium)
        $0.text = "6개의 스탬프를 모아보세요"
    }

    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.register(cell: StampCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()

    private var stamps: [Stamp] = [
        Stamp(id: 0, name: "또다른나", info: "눈덩이 1회 생성하세요", hasBadge: true),
        Stamp(id: 1, name: "100점투두", info: "투두 100개를 달성하세요", hasBadge: false),
        Stamp(id: 2, name: "꾸준한당신", info: "매일매일 투두를 완료하세요", hasBadge: false),
        Stamp(id: 3, name: "랭킹1위", info: "랭킹1위가 되어보아요", hasBadge: false),
        Stamp(id: 4, name: "눈덩이의변화", info: "눈덩이의 변화가 생겼어요", hasBadge: false),
        Stamp(id: 5, name: "마지막단계", info: "5레벨이 되었어요", hasBadge: false)
    ]

// MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initCollectionView()

        setDelegation()
        setLayout()
    }

// MARK: - Functions

    private func initCollectionView() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(cell: StampCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setDelegation() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setLayout() {
        setViewHierachy()
        setConstraints()
    }

    private func setViewHierachy() {
        view.addSubviews(collectionView, headerView)
        headerView.addSubviews(headerTitleLabel)
    }

    private func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(72)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.leading.trailing.equalToSuperview()
        }

        headerTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(18)
        }
    }

}

// MARK: - UIViewControllerTransitioningDelegate
extension StampViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - UICollectionViewDelegate
extension StampViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

        let badgeModalViewController = StampModalViewController(stamp: stamps[indexPath.item])

        badgeModalViewController.modalPresentationStyle = .custom
        badgeModalViewController.transitioningDelegate = self

        self.present(badgeModalViewController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension StampViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return stamps.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: StampCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setData(badge: stamps[indexPath.item])
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension StampViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {

            let width = UIScreen.main.bounds.width

            let cellWidth = width * (100/375)
            let cellHeight = cellWidth * (125/100)

            return CGSize(width: cellWidth, height: cellHeight)
        }

        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt section: Int
        ) -> UIEdgeInsets {
            return UIEdgeInsets(top: 72, left: 24, bottom: 24, right: 24)
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
            return 0
        }
}
