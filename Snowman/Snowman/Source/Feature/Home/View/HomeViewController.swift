//
//  HomeViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import UIKit

class HomeViewController: BaseViewController {

    private var userResponse: UserResponse? {
        didSet {
            guard let response = userResponse else { return }
            self.goals = response.goals
        }
    }

    private var goals: [GoalResponse?] = []

    private let flowLayout = ZoomAndSnapFlowLayout()

    private lazy var collectionView: UICollectionView = {
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

    private let textStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .fill
        $0.spacing = 2
    }

    private let countLabel = UILabel().then {
        $0.font = .spoqa(size: 18, family: .bold)
        $0.textColor = .systemBlue // TODO:- 색상교체
        $0.sizeToFit()
    }

    private let bubbleTodoLabel = UILabel().then {
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = .lightGray // TODO:- 색상교체
        $0.sizeToFit()
    }

    private let characterInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 6
    }

    private let levelStickerView = LevelStickerView().then {
        $0.isHidden = true
    }

    private let nameLabel = UILabel().then {
        $0.font = .spoqa(size: 24, family: .bold)
        $0.textColor = .black // TODO:- 색상교체
        $0.sizeToFit()
    }

    private let goalLabel = UILabel().then {
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = .lightGray // TODO:- 색상교체
        $0.sizeToFit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPlaceholderView()
        reloadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        registerNotificationcenter()
    }

    private func registerNotificationcenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: .refreshHomeVC, object: nil)
    }

    @objc
    private func reloadView() {
        getHome {[weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(
                at: IndexPath(item: 0, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
            self.updateGoal(goal: self.goals.first ?? nil)
        }
    }
}

extension HomeViewController {
    private func updateGoal(goal: GoalResponse?) {
        if let goal = goal {
            let snowe = Snowe(rawValue: goal.type) ?? .pink

            view.backgroundColor = snowe.color.withAlphaComponent(0.1)

            levelStickerView.isHidden = false

            var count = goal.todos.count
            for todo in goal.todos
            where todo.succeed == true {
                count -= 1
            }

            hideBubble(isHidden: false)

            nameLabel.text = goal.name
            goalLabel.text = goal.objective
            levelStickerView.type = snowe
            levelStickerView.level = goal.level

            if goal.todos.count == 0 {
                countLabel.text = ""
                bubbleTodoLabel.text = "오늘의 투두를 작성해보세요!"
            } else if count == 0 {
                countLabel.text = ""
                bubbleTodoLabel.text = snowe.doneText
            } else {
                countLabel.text = "\(count)"
                bubbleTodoLabel.text = "개의 투두가 남았어요"
            }
        } else {
            levelStickerView.isHidden = true
            nameLabel.text = "눈덩이를 생성하세요!"
            goalLabel.text = "원하는 목표를 달성할 수 있도록 도와줄게요."
            hideBubble(isHidden: true)
        }
    }

    private func setPlaceholderView() {
        nameLabel.text = ""
        goalLabel.text = ""
        levelStickerView.isHidden = true
        hideBubble(isHidden: true)
    }

    private func hideBubble(isHidden: Bool) {
        bubbleTodoLabel.isHidden = isHidden
        bubblePolygonImageView.isHidden = isHidden
        todoBubbleImageView.isHidden = isHidden
    }

    private func setOpacityCell(index: Int, alpha: CGFloat) {
        if let cell = collectionView.cellForItem(
            at: IndexPath(
                item: index,
                section: 0
            )
        ) as? SnoweCollectionViewCell {
            cell.characterImageView.alpha = alpha
        }

    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellWidthIncludeSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
        let offsetX = collectionView.contentOffset.x

        let index = (
            offsetX + collectionView.contentInset.left + collectionView.contentInset.right
        ) / cellWidthIncludeSpacing

        let roundedIndex = Int(round(index))
        if roundedIndex > -1 && roundedIndex < goals.count {
            updateGoal(goal: goals[roundedIndex])
            for index in 0...3 {
                if index == roundedIndex {
                    setOpacityCell(index: index, alpha: 1)
                } else {
                    setOpacityCell(index: index, alpha: 0.6)
                }
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if goals[indexPath.item] == nil {
            let nvc = BaseNavigationController(rootViewController: GoalQuestionViewController())
            nvc.modalPresentationStyle = .fullScreen
            present(nvc, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return goals.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: SnoweCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.updateData(goal: goals[indexPath.item])
        if indexPath.row == 0 {
            cell.characterImageView.alpha = 1
        }
        return cell
    }
}

extension HomeViewController {
    private func getHome(completion: @escaping () -> Void) {
        NetworkService.shared.user.getUsers {[weak self] result in
            switch result {
            case .success(let response):
                guard let data = response as? UserResponse else { return }
                self?.userResponse = data
                completion()
            case .requestErr(let errorResponse):
                dump(errorResponse)
            default:
                print("error")
            }
        }
    }
}

extension HomeViewController {
    private func render() {
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        view.addSubviews(
            collectionView,
            todoBubbleImageView,
            bubblePolygonImageView,
            characterInfoStackView,
            goalLabel
        )

        textStackView.addArrangedSubviews(
            countLabel,
            bubbleTodoLabel
        )

        todoBubbleImageView.addSubviews(
            textStackView
        )

        characterInfoStackView.addArrangedSubviews(
            levelStickerView,
            nameLabel
        )

        levelStickerView.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(16)
        }

        goalLabel.snp.makeConstraints {
            $0.top.equalTo(characterInfoStackView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        characterInfoStackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }

        textStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
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
