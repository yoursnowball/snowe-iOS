//
//  HomeViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import UIKit

class HomeViewController: BaseViewController {

    private var goals: [GoalResponse?] = [
        GoalResponse(
            createdAt: "",
            id: 1,
            level: 3,
            levelTodoCount: 10,
            name: "강호동",
            objective: "밥먹자",
            succeedTodoCount: 3, todos: [
                TodoResponse(createdAt: "",
                             finishedAt: "",
                             id: 1,
                             name: "배고파",
                             succeed: true
                )
            ], type: "BLUE"
        ),
        GoalResponse(
            createdAt: "",
            id: 1,
            level: 3,
            levelTodoCount: 10,
            name: "이수근",
            objective: "오동잎댄스",
            succeedTodoCount: 4, todos: [
                TodoResponse(createdAt: "",
                             finishedAt: "",
                             id: 1,
                             name: "배고파",
                             succeed: false
                )
            ], type: "BLUE"
        ),
        GoalResponse(
            createdAt: "",
            id: 1,
            level: 3,
            levelTodoCount: 10,
            name: "송민호",
            objective: "마이노 노래해",
            succeedTodoCount: 4, todos: [], type: "BLUE"
        ),
        nil
    ] {
        didSet {
            collectionView.reloadData()
        }
    }

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
        $0.text = "2"
        $0.font = .spoqa(size: 18, family: .bold)
        $0.textColor = .systemBlue // TODO:- 색상교체
        $0.sizeToFit()
    }

    private let bubbleTodoLabel = UILabel().then {
        $0.text = "개의 투두가 남았어요!"
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

    private let levelStickerView = LevelStickerView()

    private let nameLabel = UILabel().then {
        $0.text = "수줍은 눈사람"
        $0.font = .spoqa(size: 24, family: .bold)
        $0.textColor = .black // TODO:- 색상교체
        $0.sizeToFit()
    }

    private let goalLabel = UILabel().then {
        $0.text = "토익 900점 달성하기"
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = .lightGray // TODO:- 색상교체
        $0.sizeToFit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
}

extension HomeViewController {
    private func updateGoal(goal: GoalResponse?) {
        if let goal = goal {
            levelStickerView.isHidden = false

            var count = goal.todos.count
            for todo in goal.todos
            where todo.succeed == true {
                count -= 1
            }

            hideBubble(isHidden: false)

            nameLabel.text = goal.name
            goalLabel.text = goal.objective
            levelStickerView.type = Snowe(rawValue: goal.type) ?? .pink
            levelStickerView.level = goal.level

            if goal.todos.count == 0 {
                countLabel.text = ""
                bubbleTodoLabel.text = "오늘의 투두를 작성해보세요!"
            } else if count == 0 {
                countLabel.text = ""
                bubbleTodoLabel.text = "💙"
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

    private func hideBubble(isHidden: Bool) {
        bubbleTodoLabel.isHidden = isHidden
        bubblePolygonImageView.isHidden = isHidden
        todoBubbleImageView.isHidden = isHidden
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
        if roundedIndex > -1 && roundedIndex < 4 {
            updateGoal(goal: goals[roundedIndex])
            for index in 0...3 {
                if let cell = collectionView.cellForItem(
                    at: IndexPath(
                        item: index,
                        section: 0
                    )
                ) as? SnoweCollectionViewCell {
                    if index == roundedIndex {
                        cell.characterImageView.alpha = 1
                    } else {
                        cell.characterImageView.alpha = 0.6
                    }
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
        return cell
    }
}

extension HomeViewController {
    private func render() {
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
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
