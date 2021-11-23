//
//  TopTabBarViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

import SnapKit
import Then

class TopTabBarViewController: BaseViewController {

    private let menuList = ["랭킹", "뱃지", "명예의 전당"]

    private lazy var menuCount: CGFloat = CGFloat(menuList.count)

    private lazy var customTabbar: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width-80)/menuCount, height: 50)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: MenuItemCollectionViewCell.self)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()

    private lazy var mainScrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
    }

    private let indicator = UIView().then {
        $0.backgroundColor = Color.button_blue
    }

    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
        setTabItemViews()
        setLayouts()
        customTabbar.selectItem(
            at: IndexPath(item: 0, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }

}

extension TopTabBarViewController {
    private func setNavigationTitle() {
        title = "Awards"
    }

    func setTabItemViews() {
        let vc1 = RankViewController()
        vc1.view.frame = CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: mainScrollView.frame.height
        )
        addChild(vc1)
        mainScrollView.addSubview(vc1.view)

        let vc2 = UIViewController()
        vc2.view.frame = CGRect(
            x: UIScreen.main.bounds.width,
            y: 0,
            width: 0,
            height: mainScrollView.frame.height
        )
        addChild(vc2)
        mainScrollView.addSubview(vc2.view)

        let vc3 = AwardViewController()
        vc3.view.frame = CGRect(
            x: UIScreen.main.bounds.width * 2,
            y: 0,
            width: 0,
            height: mainScrollView.frame.height
        )
        addChild(vc3)
        mainScrollView.addSubview(vc3.view)
    }
}

extension TopTabBarViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return Int(menuCount)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: MenuItemCollectionViewCell = customTabbar.dequeueReusableCell(forIndexPath: indexPath)
        cell.setData(title: menuList[indexPath.row])

        return cell
    }
}

extension TopTabBarViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let newOffset = CGPoint(x: Int(UIScreen.main.bounds.width) * indexPath.row, y: 0)
        mainScrollView.setContentOffset(newOffset, animated: true)

        let customTabBarWidth = UIScreen.main.bounds.width - 80
        let page = mainScrollView.contentOffset.x / UIScreen.main.bounds.width
        indicator.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(40 + customTabBarWidth / 3 * page)
        }

        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        collectionView.isPagingEnabled = true
    }

}

extension TopTabBarViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let customTabBarWidth = UIScreen.main.bounds.width - 80
        let page = mainScrollView.contentOffset.x / UIScreen.main.bounds.width
        indicator.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(40 + customTabBarWidth / 3 * page)
        }

        let roundedIndex = Int(round(page))

        for index in 0...2 {
            if let cell = customTabbar.cellForItem(at: IndexPath(row: index, section: 0))
                as? MenuItemCollectionViewCell {
                cell.isSelected = index == roundedIndex
            }
        }
    }
}

extension TopTabBarViewController {
    private func setLayouts() {
        view.addSubviews(
            customTabbar,
            indicator,
            mainScrollView
        )

        mainScrollView.addSubview(
            contentView
        )

        customTabbar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(60)
        }

        indicator.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(40)
            $0.bottom.equalTo(customTabbar.snp.bottom)
            $0.width.equalTo(101)
            $0.height.equalTo(4)
        }

        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(customTabbar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * menuCount)
            $0.height.equalToSuperview()
        }
    }

}
