//
//  CalendarViewController.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/18.
//

import UIKit
import SnapKit
import Then








// 목표 설정 버튼 연결하기
// 년도, 월 binding


class CalendarViewController: BaseViewController {

    var goalIds: [Int] = []

    var goals: [GoalResponse] = [] {
        didSet {
            if goals.count == goalIds.count {
                let succeedCount = goals.flatMap { $0.todos }.filter { $0.succeed == true }.count
                let totalCount = goals.flatMap { $0.todos }.map { $0.succeed }.count
                todoCountLabel.text = "\(succeedCount)/\(totalCount)"

                self.todoTableView.reloadData()
            }
        }
    }

    private lazy var selectedDate: String = Date.getTodayString() {
        didSet {
            goals.removeAll()
            getTodos()
        }
    }

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    var yearMonthLabel = UILabel().then {
        $0.text = "2021 OCT"
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    var previousMonthButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_big_left"), for: .normal)
    }
    
    var nextMonthButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_big_right"), for: .normal)
    }
    
    var calendarView: CalendarView!
    
    var lineView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    var todoLabel = UILabel().then {
        $0.text = "Todo"
        $0.font = UIFont.spoqa(size: 14, family: .bold)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    var todoCountLabel = UILabel().then {
        $0.font = UIFont.spoqa(size: 14, family: .regular)
        $0.textColor = .lightGray
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

        setLayout()
        registerTarget()
        
        let myStyle = CalendarView.Style()
        
        myStyle.cellShape                = .round
        myStyle.cellColorDefault         = UIColor.clear
        myStyle.cellColorToday           = UIColor.clear
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
        
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.isScrollEnabled = false
        todoTableView.register(CalendarTodoCell.self, forCellReuseIdentifier: "CalendarTodoCell")
        
        getTodos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
}

extension CalendarViewController: CalendarViewDataSource {
    func headerString(_ date: Date) -> String? {
        return ""
    }
    
    func startDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        
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
    }}

extension CalendarViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        print("change month")
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let selectedDate = dateFormatter.string(from: date)
        print("selected date \(selectedDate)")
        
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
            cell.setData(goalResponse: goals[indexPath.item])
            cell.goalId = goalIds[indexPath.item]
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
            $0.top.leading.trailing.bottom.equalToSuperview()
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
            $0.height.equalTo(calendarView.snp.width)
            
            // 높이 동적으로 바꾸기
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
//            $0.height.equalTo(setGoalButton.snp.width).multipliedBy(53/335)
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
}
