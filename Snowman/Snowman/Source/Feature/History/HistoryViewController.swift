//
//  HistoryViewController.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import UIKit
import SnapKit
import Then

class HistoryViewController: BaseViewController {

    var goalId: Int?
    var awardAt: String?
    var historyTodoGroups: [HistoryTodoGroup] = []

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let characterImageView = UIImageView().then {
        $0.image = UIImage(named: "green_snow")
        $0.layer.cornerRadius = 32
    }
    
    let levelNameView = UIView()
    
    let levelLabel = UILabel().then {
        $0.font = UIFont.spoqa(size: 11, family: .medium)
        $0.textColor = .blue
        $0.sizeToFit()
    }
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.spoqa(size: 16, family: .regular)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    let infoStackView = UIStackView().then {
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 25
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    var infoStackSubViews: [UIStackView] = []
    var infoTitleLabel: [UILabel] = []
    var infoContentLabel: [UILabel] = []
    
    let historyLabel = UILabel().then {
        $0.font = UIFont.spoqa(size: 12, family: .bold)
        $0.text = "History"
        $0.textColor = .blue
    }
    
    var historyTableView = ContentSizedTableView().then {
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 10
        $0.separatorStyle = .none
        $0.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.isScrollEnabled = false
        historyTableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        
        getGoal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        historyTableView.reloadData()
    }
    
    func getGoal() {
        guard let goalId = goalId else { return }
        NetworkService.shared.goal.getGoal(goalId: goalId) { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response as? GoalResponse else { return }
                
                print("데이터 출력")
                print(data)
                
                self?.characterImageView.image = Snowe(rawValue: data.type)?.getImage(level: data.level)
                self?.levelLabel.text = "lv \(data.level)"
                self?.nameLabel.text = data.name

                self?.infoContentLabel[0].text = data.type
                self?.infoContentLabel[1].text = data.createdAt
                self?.infoContentLabel[2].text = self?.awardAt

                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"                
                df.locale = Locale(identifier: "ko_KR")
                df.timeZone = TimeZone(abbreviation: "KST")

                
                let dates = data.todos.map { $0.todoDate }.uniqued()
                let sortedDates = dates.sorted { df.date(from: $0)! > df.date(from: $1)! }
                var tempArr: [HistoryTodoGroup] = []
                
                for i in 0 ..< sortedDates.count {
                    let arr = data.todos.filter { $0.todoDate == sortedDates[i] }
                    if i == 0 {
                        let historyTodoData = HistoryTodoGroup(type: Snowe(rawValue: data.type)!,
                                                               title: data.name,
                                                               date: sortedDates[i],
                                                               todoTotalCount: "\(data.succeedTodoCount)/\(data.todos.count)",
                                                               historyTodos: arr.map { HistoryTodo(name: $0.name,
                                                                                                   succeed: $0.succeed) })
                        tempArr.append(historyTodoData)
                    } else {
                        let historyTodoData = HistoryTodoGroup(type: Snowe(rawValue: data.type)!,
                                                               title: nil,
                                                               date: sortedDates[i],
                                                               todoTotalCount: nil,
                                                               historyTodos: arr.map { HistoryTodo(name: $0.name,
                                                                                                   succeed: $0.succeed) })
                        tempArr.append(historyTodoData)
                    }
                }
                
                self?.historyTodoGroups = tempArr
                self?.historyTableView.reloadData()
            case .requestErr(let errorResponse):
                dump(errorResponse)
            default:
                print("history - error")
            }
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return historyTodoGroups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.selectionStyle = .none
        cell.setData(historyTodoGroup: historyTodoGroups[indexPath.item])
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HistoryViewController {
    private func setLayout() {
        
        let titleArr: [String] = ["Type", "Start", "Finish"]
        
        for i in 0...2 {
            infoStackSubViews.append(UIStackView().then {
                $0.axis = .vertical
                $0.alignment = .center
                $0.distribution = .fillEqually
            })

            infoTitleLabel.append(UILabel().then {
                $0.font = UIFont.spoqa(size: 12, family: .medium)
                $0.text = titleArr[i]
                $0.textColor = .blue
            })

            infoContentLabel.append(UILabel().then {
                $0.font = UIFont.spoqa(size: 11, family: .regular)
                $0.textColor = .black
                $0.sizeToFit()
            })
        }

        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            characterImageView,
            levelNameView,
            infoStackView,
            historyLabel,
            historyTableView)
        
        levelNameView.addSubviews(levelLabel, nameLabel)
        
        for i in 0...2 {
            infoStackView.addArrangedSubview(infoStackSubViews[i])
            infoStackSubViews[i].addArrangedSubviews(infoTitleLabel[i], infoContentLabel[i])
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(250)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(106)
            $0.height.equalTo(characterImageView.snp.width)
        }
        
        levelNameView.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview().inset(113)
            $0.height.equalTo(levelNameView.snp.width).multipliedBy(31/149)
        }
        
        levelLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-9)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.trailing.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(levelNameView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
        historyLabel.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        historyTableView.snp.makeConstraints {
            $0.top.equalTo(historyLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}
