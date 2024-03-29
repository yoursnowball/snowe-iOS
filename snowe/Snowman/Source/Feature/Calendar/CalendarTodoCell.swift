//
//  CalendarTodoCell.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import Foundation
import UIKit
import SnapKit

class CalendarTodoCell: UITableViewCell {
    var type: Snowe?
    var goalId: Int?
    var cvc: CalendarViewController?
    var selectedDate: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let characterImageView = UIImageView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.text_Primary
        label.font = UIFont.spoqa(size: 14, family: .bold)
        label.sizeToFit()
        return label
    }()

    private let todoCountLabel = UILabel().then {
        $0.textColor = Color.text_Teritary
        $0.font = UIFont.spoqa(size: 14, family: .regular)
        $0.sizeToFit()
    }
    
    private let addButton = UIButton().then {
        $0.setImage(UIImage(named: "plus_circle"), for: .normal)
    }

    private let contextView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()

    override func prepareForReuse() {
        titleLabel.text = nil
        stackView.removeAllArrangedSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        setLayout()
        stackView.isUserInteractionEnabled = true
    }

    func setData(goalResponse: GoalResponse) {
        self.type = Snowe(rawValue: goalResponse.type)
        switch self.type {
        case .blue:
            characterImageView.image = UIImage(named: "char2_blue_history")
        case .green:
            characterImageView.image = UIImage(named: "char2_green_history")
        case .orange:
            characterImageView.image = UIImage(named: "char2_orange_history")
        case .pink:
            characterImageView.image = UIImage(named: "char2_pink_history")
        case .none:
            break
        }

        titleLabel.text = goalResponse.objective
        let succeedNum = goalResponse.todos.filter { $0.succeed == true }.count
        let totalNum = goalResponse.todos.count

        todoCountLabel.text = "\(succeedNum)/\(totalNum)"

        if !goalResponse.todos.isEmpty {
            for todo in goalResponse.todos {
                addStackViewData(todo)
            }
        }
    }
    
    @objc func addTodo() {
        guard let goalId = goalId else { return }
        guard let cvc = cvc else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")

        let selectedDate = cvc.selectedDate
        guard let pastDate = formatter.date(from: selectedDate) else { return }
        guard let presentDate = Date().removeTimeStamp else { return }

        if pastDate < presentDate {
            showToastMessageAlert(message: "과거 날짜에서는 투두를\n추가할 수 없습니다.")
        } else {
            postTodo() { [weak self] result in
                for i in 0..<cvc.goals.count {
                    if cvc.goals[i].id == goalId {
                        cvc.goals[i].todos = result.todos
                        cvc.todoTableView.reloadData()

                        // 투두 생성하자마자 바로 키보드 올라오게 하는 코드인데 작동 안함
                        // 공모전 끝나고 확인할게요
                        // 코드 삭제하지 말고 놔두시면 돼요!!
    //                    let temp = self?.stackView.arrangedSubviews.last?.subviews.flatMap { $0.subviews }.filter { $0 is UITextField }
    //                    temp?.first?.becomeFirstResponder()

    //                    let temp = self?.stackView.arrangedSubviews.last?.subviews.filter { $0 is TodoView }
    //                    temp?.first?.subviews.filter { $0 is UITextField }.first?.becomeFirstResponder()

                        break
                    }
                }
            }
        }
        


    }
}

// MARK: - UI Layout & addSubview
extension CalendarTodoCell {
    private func setLayout() {
        self.addSubviews(
            titleView,
            contextView)
        
        titleView.addSubviews(characterImageView,
                              titleLabel,
                              todoCountLabel,
                              addButton)
        
        contextView.addSubview(stackView)
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(characterImageView.snp.height)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(characterImageView)
            $0.leading.equalTo(characterImageView.snp.trailing).offset(8)
        }
        
        todoCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(characterImageView)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(characterImageView)
            $0.trailing.equalToSuperview().offset(-2)
            $0.width.height.equalTo(20)
        }

        contextView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - addStackViewData
extension CalendarTodoCell {
    private func addStackViewData(_ todo: TodoResponse) {
        let backView = UIView()

        let checkButtonImage = UIImageView().then {
            $0.backgroundColor = Color.Gray100

            if todo.succeed {
                guard let type = self.type else { return }
                switch type {
                case .blue:
                    $0.image = UIImage(named: "24_check_blue")
                case .green:
                    $0.image = UIImage(named: "24_check_green")
                case .orange:
                    $0.image = UIImage(named: "24_check_orange")
                case .pink:
                    $0.image = UIImage(named: "24_check_pink")
                }
            } else {
                $0.image = nil
                $0.layer.cornerRadius = 23.33 / 2
                $0.layer.borderWidth = 1.33
                $0.layer.borderColor = Color.Gray500.cgColor
            }
        }

        let checkButton = UIButton()

        let todoNameTextField = UITextField().then {
            $0.text = todo.name
            $0.font = UIFont.spoqa(size: 14, family: .regular)
            $0.textColor = .black
            $0.delegate = self
            $0.returnKeyType = .done
        }
        
        let keyboardToolbar = UIToolbar().then {
            $0.backgroundColor = .white
            $0.sizeToFit()
        }

        let todoSelectButton = UIButton()

        let todoView = TodoView().then {
            $0.backgroundColor = Color.Gray100
            $0.layer.cornerRadius = 8
            $0.todoId = todo.id
            $0.name = todo.name
            $0.succeed = todo.succeed
        }

        backView.addSubview(todoView)
        todoView.addSubviews(
            checkButtonImage,
            checkButton,
            todoNameTextField,
            todoSelectButton)

        addSubview(backView)
        stackView.addArrangedSubview(backView)

        backView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56).priority(.high)
        }

        todoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
            $0.centerY.equalToSuperview()
        }

        checkButtonImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(23.33)
            $0.centerY.equalToSuperview()
        }

        checkButton.snp.makeConstraints {
            $0.edges.equalTo(checkButtonImage)
        }

        todoNameTextField.snp.makeConstraints {
            $0.leading.equalTo(checkButtonImage.snp.trailing).offset(12)
            $0.top.trailing.bottom.equalToSuperview()
        }

        todoSelectButton.snp.makeConstraints {
            $0.edges.equalTo(todoNameTextField)
        }
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTap))
        
        keyboardToolbar.setItems([flexibleSpace, doneButton], animated: false)
        keyboardToolbar.isUserInteractionEnabled = true
        todoNameTextField.inputAccessoryView = keyboardToolbar

        checkButton.addTarget(self, action: #selector(checkTodo), for: .touchUpInside)
        todoSelectButton.addTarget(self, action: #selector(showTodoMenu), for: .touchUpInside)
    }
    
    @objc func doneButtonDidTap() {
        self.cvc?.view.endEditing(true)
    }

    @objc func checkTodo(sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")

        guard let selectedDate = cvc?.selectedDate else { return }
        guard let pastDate = formatter.date(from: selectedDate) else { return }
        guard let presentDate = Date().removeTimeStamp else { return }

        if pastDate < presentDate {
            showToastMessageAlert(message: "과거 날짜에서는 투두를\n체크할 수 없습니다.")
        } else {
            if let todoView = sender.superview as? TodoView {
                if todoView.succeed {
                    showToastMessageAlert(message: "이미 완료한 투두입니다.")
                } else {
                    if todoView.name == "" {
                        showToastMessageAlert(message: "투두를 입력해주세요.")
                    } else {
                        putTodo(todoId: todoView.todoId,
                                name: todoView.name,
                                succeed: !todoView.succeed) { [weak self] result in

                            guard let goalId = self?.goalId else { return }
                            guard let cvc = self?.cvc else { return }

                            for i in 0..<cvc.goals.count {
                                if cvc.goals[i].id == goalId {
                                    guard let levelChange = LevelChange(rawValue: result.levelChange) else { return }
                                    switch levelChange {
                                    case .keep, .levelDown:
                                        break
                                    case .levelUp:
                                        let levelUpView = LevelUpViewController()
                                        levelUpView.snoweImage = Snowe(rawValue: cvc.goals[i].type)?.getImage(level: cvc.goals[i].level + 1)
                                        levelUpView.modalPresentationStyle = .fullScreen
                                        cvc.present(levelUpView, animated: true, completion: nil)
                                    }

                                    for j in 0..<cvc.goals[i].todos.count {
                                        if cvc.goals[i].todos[j].id == todoView.todoId {
                                            cvc.goals[i].todos[j].succeed = !cvc.goals[i].todos[j].succeed
                                            cvc.todoTableView.reloadData()
                                            break
                                        }
                                    }
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @objc func showTodoMenu(sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")

        guard let selectedDate = cvc?.selectedDate else { return }
        guard let pastDate = formatter.date(from: selectedDate) else { return }
        guard let presentDate = Date().removeTimeStamp else { return }

        if pastDate < presentDate {
            showToastMessageAlert(message: "과거 날짜에서는 투두를\n수정할 수 없습니다.")
        } else {
            if let todoView = sender.superview as? TodoView {
                if let textfield = (todoView.subviews.filter { $0 is UITextField }.first) as? UITextField {
                    if textfield.text == "" {
                        textfield.becomeFirstResponder()
                    } else {
                        let actionsheet = UIAlertController(title: "투두 설정", message: nil, preferredStyle: .actionSheet)

                        let doneAction = UIAlertAction(title: "완료", style: .default) { _ in
                            if todoView.succeed {
                                self.showToastMessageAlert(message: "이미 완료한 투두입니다.")
                            } else {
                                self.putTodo(todoId: todoView.todoId,
                                             name: todoView.name,
                                             succeed: !todoView.succeed) { [weak self] result in

                                    guard let goalId = self?.goalId else { return }
                                    guard let cvc = self?.cvc else { return }

                                    for i in 0..<cvc.goals.count {
                                        if cvc.goals[i].id == goalId {
                                            guard let levelChange = LevelChange(rawValue: result.levelChange) else { return }
                                            switch levelChange {
                                            case .keep, .levelDown:
                                                break
                                            case .levelUp:
                                                let levelUpView = LevelUpViewController()
                                                levelUpView.snoweImage = Snowe(rawValue: cvc.goals[i].type)?.getImage(level: cvc.goals[i].level + 1)
                                                levelUpView.modalPresentationStyle = .fullScreen
                                                cvc.present(levelUpView, animated: true, completion: nil)
                                            }

                                            for j in 0..<cvc.goals[i].todos.count {
                                                if cvc.goals[i].todos[j].id == todoView.todoId {
                                                    cvc.goals[i].todos[j].succeed = !cvc.goals[i].todos[j].succeed
                                                    cvc.todoTableView.reloadData()
                                                    break
                                                }
                                            }
                                            break
                                        }
                                    }
                                }
                            }
                        }

                        let modifyAction = UIAlertAction(title: "수정", style: .default) { _ in
                            textfield.becomeFirstResponder()
                        }

                        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                            self.deleteTodo(todoId: todoView.todoId) {
                                guard let goalId = self.goalId else { return }
                                guard let cvc = self.cvc else { return }
                                
                                for i in 0..<cvc.goals.count {
                                    if cvc.goals[i].id == goalId {
                                        for j in 0..<cvc.goals[i].todos.count {
                                            if cvc.goals[i].todos[j].id == todoView.todoId {
                                                cvc.goals[i].todos = cvc.goals[i].todos.filter { $0.id != todoView.todoId }
                                                cvc.todoTableView.reloadData()
                                                break
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                        }

                        let actionCancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)

                        actionsheet.addAction(doneAction)
                        actionsheet.addAction(modifyAction)
                        actionsheet.addAction(deleteAction)
                        actionsheet.addAction(actionCancel)
                        
                        self.cvc?.present(actionsheet, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    func showToastMessageAlert(message: String) {
        let alert = UIAlertController(title: message,
                                      message: "",
                                      preferredStyle: .alert)

        cvc?.present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            alert.dismiss(animated: true)
        }
    }
}

extension CalendarTodoCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let todoView = textField.superview as? TodoView, let text = textField.text {
            putTodo(todoId: todoView.todoId,
                    name: text,
                    succeed: todoView.succeed) { [weak self] result in
                guard let goalId = self?.goalId else { return }
                guard let cvc = self?.cvc else { return }

                for i in 0..<cvc.goals.count {
                    if cvc.goals[i].id == goalId {
                        for j in 0..<cvc.goals[i].todos.count {
                            if cvc.goals[i].todos[j].id == todoView.todoId {
                                cvc.goals[i].todos[j].name = text
                                cvc.todoTableView.reloadData()
                                break
                            }
                        }
                        break
                    }
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) { [self] in
            cvc?.view.frame.origin.y = 0
            textField.resignFirstResponder()
        }
        return true
    }
}

extension CalendarTodoCell {
    func postTodo(completion: @escaping(PostTodoResponse) -> Void) {
        guard let goalId = goalId else { return }
        guard let date = selectedDate else { return }

        NetworkService.shared.todo.postTodo(goalId: goalId,
                                            date: date,
                                            todo: "") { result in
            switch result {
            case .success(let response):
                guard let data = response as? PostTodoResponse else { return }
                completion(data)
            case .requestErr(let errorResponse):
                dump(errorResponse)
            default:
                print("calendar todo cell - postTodo error")
            }
        }
    }

    func putTodo(todoId: Int, name: String, succeed: Bool, completion: @escaping(PutTodoResponse) -> Void) {
        guard let goalId = goalId else { return }
        NetworkService.shared.todo.putTodo(goalId: goalId,
                                           todoId: todoId,
                                           name: name,
                                           succeed: succeed) { result in
            switch result {
            case .success(let response):
                guard let data = response as? PutTodoResponse else { return }
                completion(data)
            case .requestErr(let errorResponse):
                dump(errorResponse)
            default:
                print("calendar todo cell - putTodo error")
            }
        }
    }

    func deleteTodo(todoId: Int, completion: @escaping() -> Void) {
        guard let goalId = goalId else { return }
        NetworkService.shared.todo.deleteTodo(goalId: goalId, todoId: todoId) { result in
            switch result {
            case .success(_):
                completion()
            case .requestErr(let errorResponse):
                dump(errorResponse)
                guard let data = errorResponse as? ErrorResponse else { return }
                self.cvc?.showToastMessageAlert(message: data.message)
            default:
                print("calendar todo cell - deleteTodo error")
            }
        }
    }
}
