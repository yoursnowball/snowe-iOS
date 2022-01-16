//
//  CalendarViewController.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/18.
//

import UIKit
import SnapKit
import Then

class CalendarViewController: BaseViewController {

    var manySucceedType: Snowe?
    var succeedCount: Int?
    var goalIds: [Int] = []
    var goalsForCalendar: Dictionary<String, GoalSummary> = [:] {
        didSet {
            self.calendarView.reloadData()
        }
    }

    // 과거 날짜 선택했을 때 어떻게 할지 생각하기
    // 과거 날짜만으로 이전 목표, 투두 가져오는 API가 없음
    var goals: [GoalResponse] = [] {
        didSet {
            if goals.count == goalIds.count {
                goals = goals.sorted(by: { $0.id < $1.id })

                succeedCount = goals.flatMap { $0.todos }.filter { $0.succeed == true }.count
                let totalCount = goals.flatMap { $0.todos }.map { $0.succeed }.count
                todoCountLabel.text = "\(succeedCount ?? 0)/\(totalCount)"

                self.todoTableView.reloadData()
            } else {

            }
        }
    }

    lazy var selectedDate: String = Date.getTodayString() {
        didSet {
            goals.removeAll()
            getTodos()
        }
    }

    lazy var numberOfWeeks: Int = Date.numberOfWeeksInMonth(Date()) {
        didSet {
            switch numberOfWeeks {
            case 4: calendarView.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: self.view.frame.size.width - 40 - 30 - 30)
            case 5:
                self.calendarView.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: self.view.frame.size.width - 40 - 30)
            default:
                self.calendarView.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: self.view.frame.size.width - 40 + 30)
            }
        }
    }

    var topY: CGFloat = 0

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    let contentView: UIView = {
        let view = UIView()
        return view
    }()

    var yearMonthLabel = UILabel().then {
        $0.textColor = Color.text_Primary
        $0.font = UIFont.spoqa(size: 16, family: .bold)
    }

    var previousMonthButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_big_left"), for: .normal)
    }

    var nextMonthButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_big_right"), for: .normal)
    }

    var calendarView: CalendarView!

    var lineView = UIView().then {
        $0.backgroundColor = Color.Gray300
    }

    var todoLabel = UILabel().then {
        $0.text = "Todo"
        $0.font = UIFont.spoqa(size: 14, family: .bold)
        $0.textColor = Color.text_Primary
        $0.sizeToFit()
    }

    var todoCountLabel = UILabel().then {
        $0.font = UIFont.spoqa(size: 14, family: .regular)
        $0.textColor = Color.text_Teritary
        $0.sizeToFit()
    }

    var todoTableView = ContentSizedTableView().then {
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 10
        $0.separatorStyle = .none
        $0.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    var noGoalLabel = UILabel().then {
        $0.font = UIFont.spoqa(size: 14, family: .regular)
        $0.textColor = Color.text_Teritary
        $0.text = "아직 목표 설정을 하지 않았어요!"
        $0.textAlignment = .center
    }

    var setGoalButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = Color.button_blue
        $0.setTitle("목표 설정", for: .normal)
        $0.titleLabel?.font = UIFont.spoqa(size: 18, family: .bold)
        $0.setTitleColor(Color.Gray000, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        makeCloseButton()

        if goalIds.count == 0 {
            noGoalLabel.isHidden = false
            setGoalButton.isHidden = false
            todoTableView.isHidden = true
        } else {
            noGoalLabel.isHidden = true
            setGoalButton.isHidden = true
            todoTableView.isHidden = false
        }

        calendarView = CalendarView()
        calendarView.cvc = self

        setLayout()
        registerTarget()

        let myStyle = CalendarView.Style()

        myStyle.cellShape                = .round
        myStyle.cellColorDefault         = UIColor.clear
        myStyle.cellColorToday           = Color.line_blue
        myStyle.cellSelectedBorderColor  = UIColor.clear
        myStyle.cellSelectedColor        = UIColor.clear
        myStyle.cellEventColor           = UIColor.clear
        myStyle.headerTextColor          = UIColor.black
        myStyle.headerHeight             = 30

        myStyle.cellTextColorDefault     = Color.text_Secondary
        myStyle.cellTextColorToday       = Color.text_Secondary
        myStyle.cellTextColorWeekend     = Color.text_Secondary
        myStyle.cellColorOutOfRange      = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        myStyle.cellSelectedTextColor    = Color.line_blue

        myStyle.headerBackgroundColor    = UIColor.white
        myStyle.weekdaysBackgroundColor  = UIColor.white
        myStyle.firstWeekday             = .sunday
        myStyle.locale                   = Locale(identifier: "ko_KR")

        myStyle.cellFont = UIFont.systemFont(ofSize: 16, weight: .heavy)
        myStyle.headerFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        myStyle.weekdaysFont = UIFont.systemFont(ofSize: 16, weight: .heavy)

        calendarView.style = myStyle

        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = true

        calendarView.backgroundColor = UIColor.white

        let today = Date()
        self.calendarView.selectDate(today)
        self.calendarView.setDisplayDate(today)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")

        yearMonthLabel.text = dateFormatter.string(from: today).uppercased()

        dateFormatter.dateFormat = "yyyy-MM"
        let yearMonth = dateFormatter.string(from: today)
        calendarView.yearMonth = yearMonth

        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.isScrollEnabled = false
        todoTableView.register(CalendarTodoCell.self, forCellReuseIdentifier: "CalendarTodoCell")

        getTodos()
        getGoalsForCalendar(start: Date().startOfMonth(),
                            end: Date().endOfMonth())

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowForTextField), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideForTextField), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topY = UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func keyboardWillShowForTextField(notification _: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = self.topY - self.todoTableView.frame.origin.y
        }
    }

    @objc func keyboardWillHideForTextField(notification _: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }

    func getTodos() {
        for goalId in goalIds {
            NetworkService.shared.goal.getGoal(goalId: goalId,
                                               date: selectedDate) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let data = response as? GoalResponse else { return }
                    self?.goals.append(data)
                case .requestErr(let errorResponse):
                    dump(errorResponse)
                default:
                    print("calendar getTodos - error")
                }
            }
        }
    }

    func getGoalsForCalendar(start: String, end: String) {
        NetworkService.shared.goal.getGoalsForCalendar(start: start, end: end) { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response as? GetGoalsForCalendarResponse else { return }
                self?.goalsForCalendar = data.goals
            case .requestErr(let errorResponse):
                dump(errorResponse)
            default:
                print("calendar getGoalsForCalendar - error")
            }
        }
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

extension CalendarViewController: CalendarViewDataSource {
    func headerString(_ date: Date) -> String? {
        return ""
    }

    func startDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -12

        let today = Date()
        let threeMonthsAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!

        return threeMonthsAgo
    }

    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 12

        let today = Date()
        let twoYearsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!

        return twoYearsFromNow
    }
}

extension CalendarViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")

        var endDay: String?

        switch Int(dateFormatter.string(from: date)) {
        case 1, 3, 5, 7, 8, 10, 12: endDay = "-31"
        case 4, 6, 9, 11: endDay = "-30"
        case 2: endDay = "-27" //윤년은 나중에 체크...
        default:
            break
        }

        dateFormatter.dateFormat = "yyyy-MM"
        let yearMonth = dateFormatter.string(from: date)
        let start = yearMonth + "-01"
        if let endDay = endDay {
            let end = yearMonth + endDay
            getGoalsForCalendar(start: start, end: end)
        }
        calendarView.yearMonth = yearMonth


        dateFormatter.dateFormat = "yyyy MMM"
        yearMonthLabel.text = dateFormatter.string(from: date).uppercased()

        numberOfWeeks = Date.numberOfWeeksInMonth(date)
    }

    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
    }

    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")

        selectedDate = dateFormatter.string(from: date)

        // 오늘 이전 날짜면 투두 입력 못 하게 막기

        return true
    }

    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
    }

    func calendar(_ calendar: CalendarView, didLongPressDate date : Date, withEvents events: [CalendarEvent]?) {
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return goalIds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CalendarTodoCell = todoTableView.dequeueReusableCell(withIdentifier: "CalendarTodoCell", for: indexPath) as! CalendarTodoCell
        cell.selectionStyle = .none
        cell.cvc = self
        cell.selectedDate = selectedDate

        if !goals.isEmpty {
            cell.setData(goalResponse: goals[indexPath.row])
            cell.goalId = goalIds[indexPath.row]
        }

        cell.contentView.isUserInteractionEnabled = false
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CalendarViewController {
    private func setLayout() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            yearMonthLabel,
            previousMonthButton,
            nextMonthButton,
            calendarView,
            lineView,
            todoLabel,
            todoCountLabel,
            todoTableView,
            noGoalLabel,
            setGoalButton)

        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(250)
        }

        yearMonthLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
            $0.width.equalTo(80)
        }

        previousMonthButton.snp.makeConstraints {
            $0.centerY.equalTo(yearMonthLabel)
            $0.width.height.equalTo(16)
            $0.leading.equalTo(yearMonthLabel.snp.trailing).offset(4)
        }

        nextMonthButton.snp.makeConstraints {
            $0.centerY.equalTo(yearMonthLabel)
            $0.width.height.equalTo(16)
            $0.leading.equalTo(previousMonthButton.snp.trailing).offset(4)
        }

        calendarView.snp.makeConstraints {
            $0.top.equalTo(yearMonthLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)

            switch numberOfWeeks {
            case 4: $0.height.equalTo(self.view.frame.size.width - 40 - 30 - 30)
            case 5: $0.height.equalTo(self.view.frame.size.width - 40 - 30)
            default: $0.height.equalTo(self.view.frame.size.width - 40 + 30)
            }
        }

        lineView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(1)
        }

        todoCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(lineView)
            $0.trailing.equalToSuperview().offset(-20)

        }

        todoLabel.snp.makeConstraints {
            $0.centerY.equalTo(lineView)
            $0.trailing.equalTo(todoCountLabel.snp.leading).offset(-5)
            $0.leading.equalTo(lineView.snp.trailing).offset(6)
        }

        todoTableView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }

        noGoalLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(lineView.snp.bottom).offset(108)
        }

        setGoalButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-34)
            $0.height.equalTo(53)
            $0.top.equalTo(noGoalLabel.snp.bottom).offset(165)
        }
    }
}

extension CalendarViewController {
    private func registerTarget() {
        [previousMonthButton, nextMonthButton, setGoalButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapAction(_:)), for: .touchUpInside)
        }
    }

    @objc
    private func buttonTapAction(_ sender: UIButton) {
        switch sender {
        case previousMonthButton:
            self.calendarView.goToPreviousMonth()
        case nextMonthButton:
            self.calendarView.goToNextMonth()
        case setGoalButton:
            let nvc = BaseNavigationController(rootViewController: GoalQuestionViewController())
            nvc.modalPresentationStyle = .fullScreen
            present(nvc, animated: true, completion: nil)
        default:
            return
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
}
