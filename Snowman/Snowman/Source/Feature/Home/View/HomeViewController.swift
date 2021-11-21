//
//  HomeViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import UIKit

class HomeViewController: BaseViewController {

    lazy var collectionView: UICollectionView = {
        let flowLayout = ZoomAndSnapFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.collectionViewLayout = flowLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(cell: SnoweCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private let todoBubbleImageView = UIImageView().then {
        $0.image = Image.todoCountBubble
    }

    private let bubblePolygonImageView = UIImageView().then {
        $0.image = Image.bubblePolygon
        $0.contentMode = .scaleAspectFit
    }

    private let checkImageView = UIImageView().then {
        $0.image = Image.checkBold
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
}

extension HomeViewController {
    private func render() {
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        todoBubbleImageView.addSubviews(checkImageView)
        view.addSubviews(collectionView, todoBubbleImageView, bubblePolygonImageView)

        checkImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(133)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(195)
        }

        todoBubbleImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(collectionView.snp.top).offset(-20)
        }

        bubblePolygonImageView.snp.makeConstraints {
            $0.centerX.equalTo(todoBubbleImageView.snp.centerX)
            $0.bottom.equalTo(todoBubbleImageView.snp.bottom).offset(10)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 4
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: SnoweCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
}
