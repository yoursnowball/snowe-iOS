//
//  HomeTodoCell.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/28.
//

import Foundation
import UIKit
import SnapKit

class HomeTodoCell: UITableViewCell {
    var type: Snowe?
    var goalId: Int?
    var hvc: HomeViewController?
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

    private let contextView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()

    private let emptyTodoLabel = UILabel().then {
        $0.font = UIFont.spoqa(size: 14, family: .regular)
        $0.textColor = Color.text_Teritary
        $0.text = "아직 투두가 작성되지 않았어요 😢"
        $0.sizeToFit()
        $0.isHidden = true
    }

    override func prepareForReuse() {
        titleLabel.text = nil
        stackView.removeAllArrangedSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
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
            emptyTodoLabel.isHidden = true
            for todo in goalResponse.todos {
                addStackViewData(todo)
            }
        } else {
            emptyTodoLabel.isHidden = false
        }
    }
}

// MARK: - UI Layout & addSubview
extension HomeTodoCell {
    private func setLayout() {
        self.addSubviews(
            titleView,
            contextView,
            emptyTodoLabel)
        
        titleView.addSubviews(characterImageView,
                              titleLabel,
                              todoCountLabel)
        
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

        contextView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        emptyTodoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - addStackViewData
extension HomeTodoCell {
    private func addStackViewData(_ todo: TodoResponse) {
        let backView = UIView()

        let checkButtonImage = UIImageView().then {
            $0.backgroundColor = Color.Gray000

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
            $0.backgroundColor = Color.Gray000
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
            $0.height.greaterThanOrEqualTo(56)
//            $0.height.equalTo(56)
        }

        todoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(-4)
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
        self.hvc?.view.endEditing(true)
    }

    @objc func checkTodo(sender: UIButton) {
        if let todoView = sender.superview as? TodoView {
            putTodo(todoId: todoView.todoId,
                    name: todoView.name,
                    succeed: !todoView.succeed) { [weak self] result in
                if result.isLevelUp {
                    // 레벨업 됐을 때 화면
                } else {
                    guard let goalId = self?.goalId else { return }
                    guard let hvc = self?.hvc else { return }

                    for i in 0..<hvc.goals.count {
                        if hvc.goals[i]?.id == goalId {
                            if let goal = hvc.goals[i] {
                                for j in 0..<goal.todos.count {
                                    if goal.todos[j].id == todoView.todoId {
                                        hvc.goals[i]?.todos[j].succeed = !goal.todos[j].succeed
                                        hvc.todoTableView.reloadData()
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

    @objc func showTodoMenu(sender: UIButton) {
        if let todoView = sender.superview as? TodoView {
            todoView.subviews.filter { $0 is UITextField }.first?.becomeFirstResponder()
        }

        // 수정
        // 삭제
        // 완료
        // 취소
    }
}

extension HomeTodoCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let todoView = textField.superview as? TodoView, let text = textField.text {
            putTodo(todoId: todoView.todoId,
                    name: text,
                    succeed: todoView.succeed) { [weak self] result in
                if result.isLevelUp {
                    // 레벨업 됐을 때 화면
                } else {
                    guard let goalId = self?.goalId else { return }
                    guard let hvc = self?.hvc else { return }

                    for i in 0..<hvc.goals.count {
                        if hvc.goals[i]?.id == goalId {
                            if let goal = hvc.goals[i] {
                                for j in 0..<goal.todos.count {
                                    if goal.todos[j].id == todoView.todoId {
                                        hvc.goals[i]?.todos[j].name = text
                                        hvc.todoTableView.reloadData()
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) { [self] in
            hvc?.view.frame.origin.y = 0
            textField.resignFirstResponder()
        }
        return true
    }
}

extension HomeTodoCell {
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
            default:
                print("calendar todo cell - deleteTodo error")
            }
        }
    }
}
