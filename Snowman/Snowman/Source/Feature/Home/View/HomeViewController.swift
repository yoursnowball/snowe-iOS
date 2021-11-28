//
//  HomeViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import UIKit

// swiftlint:disable file_length
final class HomeViewController: BaseViewController {

    private var userResponse: UserResponse? {
        didSet {
            guard let response = userResponse else { return }
            self.goals = response.goals

            if !goals.isEmpty {
                goalIds.removeAll()

                for goal in goals {
                    if let id = goal?.id {
                        goalIds.append(id)
                    }
                }
            }
        }
    }

    var goals: [GoalResponse?] = []
    private var goalIds: [Int] = []

    private let maxIndex: Int = 4

    private lazy var currentIndex: Int = 0 {
        didSet {
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else {return}
                if self.currentIndex == 0 {
                    self.leftChervonButton.alpha = 0
                    self.rightChervonButton.alpha = 1
                } else if self.currentIndex == self.maxIndex - 1 {
                    self.rightChervonButton.alpha = 0
                    self.leftChervonButton.alpha = 1
                } else {
                    self.rightChervonButton.alpha = 1
                    self.leftChervonButton.alpha = 1
                }
            }
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
        $0.font = .spoqa(size: 18, family: .bold)
        $0.sizeToFit()
    }

    private let bubbleTodoLabel = UILabel().then {
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = Color.text_Secondary
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
        $0.textColor = Color.text_Primary
        $0.sizeToFit()
    }

    private let goalLabel = UILabel().then {
        $0.font = .spoqa(size: 16, family: .regular)
        $0.textColor = Color.text_Secondary
        $0.sizeToFit()
    }

    lazy var todoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTodoCell.self, forCellReuseIdentifier: "HomeTodoCell")
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()

    private lazy var leftChervonButton = UIButton().then {
        $0.setImage(
            Image.chevronLeftBold.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        $0.adjustsImageWhenHighlighted = false
    }

    private lazy var rightChervonButton = UIButton().then {
        $0.setImage(
            Image.chevronRightBold.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        $0.adjustsImageWhenHighlighted = false
    }

    private let calendarButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar_check"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.layer.shadowColor = UIColor(red: 0.737, green: 0.737, blue: 0.737, alpha: 1).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 8
        $0.layer.shadowOffset = .zero
        $0.layer.shadowPath = nil
        $0.backgroundColor = Color.button_blue
    }

    private let generator = UIImpactFeedbackGenerator(style: .light)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentIndex = 0
        setPlaceholderView()
        reloadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        registerTarget()
        registerNotificationcenter()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillHideForTextField(notification _: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }

    private func registerNotificationcenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: .refreshHomeVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideForTextField), name: UIResponder.keyboardWillHideNotification, object: nil)

        registerForKeyboardNotification()
    }

    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustView),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    @objc private func adjustView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (
            userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue else { return }

        let adjustmentHeight = keyboardFrame.height

        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -adjustmentHeight
        }
    }

    @objc
    private func reloadView() {
        getHome { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(
                at: IndexPath(item: self.currentIndex, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
            self.updateGoal(goal: self.goals.first ?? nil)
            self.todoTableView.reloadData()
        }
    }

    @objc func touchRankButton() {
        guard let level = self.goals[currentIndex]?.level else { return }

        if level > 5 {
            let popUpView = PopUpViewController()
            popUpView.modalTransitionStyle = .crossDissolve
            popUpView.modalPresentationStyle = .overCurrentContext
            popUpView.delegate = self
            popUpView.setText(
                title: "",
                content: "명예의 전당으로 보내시면\n더 이상 투두를 작성할 수 없어요!",
                rightButtonText: "보내기"
            )
            present(popUpView, animated: true, completion: nil)
        } else {
            showToastMessageAlert(message: "레벨5가 되기 전에는 명예의 전당으로 보낼 수 없습니다.")
        }
    }

    func showToastMessageAlert(message: String) {
        let alert = UIAlertController(title: message,
                                      message: "",
                                      preferredStyle: .alert)

        present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            alert.dismiss(animated: true)
        }
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

extension HomeViewController {
    private func updateGoal(goal: GoalResponse?) {
        if let goal = goal {
            todoTableView.isHidden = false
            todoTableView.reloadData()

            let snowe = Snowe(rawValue: goal.type) ?? .pink

            view.backgroundColor = snowe.bgColor
            countLabel.textColor = snowe.lineColor
            leftChervonButton.tintColor = snowe.todoColor
            rightChervonButton.tintColor = snowe.todoColor

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
            setPlaceholderView()
            nameLabel.text = "눈덩이를 생성하세요!"
            goalLabel.text = "원하는 목표를 달성할 수 있도록 도와줄게요."
            todoTableView.isHidden = true
        }
    }

    private func setPlaceholderView() {
        nameLabel.text = ""
        goalLabel.text = ""
        view.backgroundColor = Color.bg_blue
        levelStickerView.isHidden = true
        hideBubble(isHidden: true)
        leftChervonButton.tintColor = Color.todo_blue
        rightChervonButton.tintColor = Color.todo_blue
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
        if scrollView is UICollectionView {
            let cellWidthIncludeSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
            let offsetX = collectionView.contentOffset.x

            let index = (
                offsetX + collectionView.contentInset.left + collectionView.contentInset.right
            ) / cellWidthIncludeSpacing

            let roundedIndex = Int(round(index))

            if roundedIndex > -1 && roundedIndex < maxIndex {
                if goals.count > 0 {
                    updateGoal(goal: goals[roundedIndex % goals.count])
                    currentIndex = roundedIndex
                    setOpacityCell(index: roundedIndex, alpha: 1)
                    if roundedIndex > 0 && roundedIndex < maxIndex - 1 {
                        setOpacityCell(index: roundedIndex-1, alpha: 0.5)
                        setOpacityCell(index: roundedIndex+1, alpha: 0.5)
                    }
                }
            }
        }
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        if scrollView is UICollectionView {
            generator.impactOccurred()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTodoCell = todoTableView.dequeueReusableCell(indexPath: indexPath)
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
        cell.hvc = self

        if !goals.isEmpty {
            if let goal = goals[currentIndex] {
                cell.setData(goalResponse: goal)
                cell.goalId = goalIds[indexPath.row]
            }
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let buttonView = UIView()

        let label = UILabel().then {
            $0.text = "5레벨 달성시 활성화"
            $0.textColor = Color.text_Teritary
            $0.font = UIFont.spoqa(size: 12, family: .regular)
            $0.sizeToFit()
        }

        let rankButton = UIButton().then {
            $0.titleLabel?.font = UIFont.spoqa(size: 18, family: .bold)
            $0.setTitle("명예의 전당", for: .normal)
            $0.layer.cornerRadius = 10

            if !goals.isEmpty {
                if let goal = goals[currentIndex] {
                    if goal.level > 5 {
                        $0.backgroundColor = Color.button_blue
                        $0.setTitleColor(Color.Gray000, for: .normal)
                        $0.isEnabled = false
                    } else {
                        $0.backgroundColor = Color.Gray300
                        $0.setTitleColor(Color.text_Teritary, for: .normal)
                        $0.isEnabled = true
                    }
                }
            }
        }

        buttonView.addSubviews(label, rankButton)

        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview()
        }

        rankButton.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(53)
        }

        rankButton.addTarget(self, action: #selector(touchRankButton), for: .touchUpInside)

        return buttonView
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if goals[indexPath.item % goals.count] == nil {
            generator.impactOccurred()

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
        return maxIndex
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: SnoweCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

        if goals.count>0 {
            cell.updateData(goal: goals[indexPath.item % goals.count])
        }

        if indexPath.item == currentIndex {
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
                print("home - get home error")
            }
        }
    }
}

extension HomeViewController {
    // swiftlint:disable function_body_length
    private func render() {
        view.addSubviews(
            collectionView,
            todoBubbleImageView,
            bubblePolygonImageView,
            characterInfoStackView,
            goalLabel,
            leftChervonButton,
            rightChervonButton,
            todoTableView,
            calendarButton
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

        leftChervonButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(collectionView.snp.centerY).offset(12)
            $0.centerX.equalTo(collectionView.snp.centerX).offset(-115)
        }

        rightChervonButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(collectionView.snp.centerY).offset(12)
            $0.centerX.equalTo(collectionView.snp.centerX).offset(115)
        }

        todoTableView.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }

        calendarButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-44)
            $0.width.height.equalTo(self.view.frame.size.width * 56 / 375)
        }

        calendarButton.layer.cornerRadius = (self.view.frame.size.width * 56 / 375) / 2
    }

    func registerTarget() {
        calendarButton.addTarget(self, action: #selector(pushCalendarVC), for: .touchUpInside)
    }

    @objc func pushCalendarVC() {
        let calendarVC = CalendarViewController()
        calendarVC.goalIds = self.goalIds
        self.navigationController?.pushViewController(calendarVC, animated: true)
    }
}

extension HomeViewController: PopUpActionDelegate {
    func touchRightButton(button: UIButton) {
        guard let goalId = self.goals[currentIndex]?.id else { return }

        NetworkService.shared.goal.postAwards(goalId: goalId) { [weak self] result in
            switch result {
            case .success:
                // 명예의 전당 보내고 난 뒤의 받는 데이터
//            case .success(let response):
//                guard let data = response as? Award else { return }
                self?.reloadView()
                let awardVC = AwardViewController()
                self?.present(awardVC, animated: true)
            case .requestErr(let errorResponse):
                dump(errorResponse)
            default:
                print("home - post award error")
            }
        }
    }
}
