//
//  TodoCell.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import Foundation
import UIKit
import SnapKit

class TodoCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var todoListData: TodoListGroup!

    private let titleView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    private let characterImageView = UIImageView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "토익 900점 달성하기"
        label.textColor = .black
        label.font = UIFont.spoqa(size: 14, family: .bold)
        label.sizeToFit()
        return label
    }()
    
    private let todoCountLabel = UILabel().then {
        $0.text = "0/0"
        $0.textColor = .lightGray
        $0.font = UIFont.spoqa(size: 14, family: .regular)
        $0.sizeToFit()
    }
    
    private let addButton = UIButton().then {
        $0.setImage(UIImage(named: "plus_circle"), for: .normal)
    }

    private let contextView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()

    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        return sv
    }()

    private var stackViewData: [TodoList] = []

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

    func setData(data: TodoListGroup) {
        titleLabel.text = data.title
        self.todoListData = data
        
        switch data.characterType {
            case .blue:
                characterImageView.image = UIImage(named: "blue_snow")
            case .green:
                characterImageView.image = UIImage(named: "green_snow")
            case .orange:
                characterImageView.image = UIImage(named: "orange_snow")
            case .pink:
                characterImageView.image = UIImage(named: "pink_snow")
        }

        for list in data.todoList {
            addStackViewData(todoList: list)
        }
    }
}

// MARK: - UI Layout & addSubview
extension TodoCell {
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
extension TodoCell {
    private func addStackViewData(todoList: TodoList) {
        let backView: UIView = {
            let v = UIView()
            return v
        }()
        
        let checkButtonView = CheckButtonView().then {
            $0.backgroundColor = .lightGray
            $0.characterType = todoList.characterType
            $0.isDone = todoList.isDone
        }
        
        let checkButtonImage = UIImageView().then {
            if todoList.isDone {
                
                // 체크표시가 보이게 배경색 변경
                $0.backgroundColor = .lightGray
                
                switch todoList.characterType {
                case .blue:
                    $0.image = UIImage(named: "24_check_blue")
                case .green:
                    $0.image = UIImage(named: "24_check_blue")
                case .orange:
                    $0.image = UIImage(named: "24_check_blue")
                case .pink:
                    $0.image = UIImage(named: "24_check_blue")
                }
            } else {
                $0.image = nil
                $0.layer.cornerRadius = 23.33 / 2
                $0.backgroundColor = .white
                $0.layer.borderWidth = 1.33
                $0.layer.borderColor = UIColor.gray.cgColor
            }
        }
        
        let todoTitleLabel = UILabel().then {
            $0.text = todoList.title
            $0.font = UIFont.spoqa(size: 14, family: .regular)
            $0.textColor = .black
        }
        
        let view = UIView().then {
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 8
        }
        
        stackViewData.append(todoList)
        
        backView.addSubview(view)
        view.addSubviews(
            checkButtonView,
            checkButtonImage,
            todoTitleLabel)
        
        addSubview(backView)
        
        stackView.addArrangedSubview(backView)
        
        backView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(56)
//            $0.height.equalTo(56)
        }

        view.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        checkButtonView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(23.33)
            $0.centerY.equalToSuperview()
        }
        
        checkButtonImage.snp.makeConstraints {
            $0.edges.equalTo(checkButtonView)
        }
        
        todoTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButtonView.snp.trailing).offset(12)
            $0.centerY.equalTo(checkButtonView)
            $0.trailing.equalToSuperview()
        }
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(checkTodo))
        checkButtonView.addGestureRecognizer(gesture)
        
        
        
        // checkButton에 함수 연결하기
    }

    @objc func checkTodo(_ sender: UIGestureRecognizer) {
        if let view = sender.view as? CheckButtonView {
            
            
            // todoListData 비교해서 바꾸고 api 날리기
            // stackView  removeAllSubviews 하고
            // 다시 setData
            
            if view.isDone {
                
            } else {
                
            }
            
        }
    }
}

class CheckButtonView: UIView {
    var characterType: CharacterType!
    var isDone: Bool!
}
