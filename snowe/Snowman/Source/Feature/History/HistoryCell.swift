//
//  HistoryCell.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import Foundation
import UIKit
import SnapKit

class HistoryCell: UITableViewCell {
    var type: Snowe?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private let titleView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    private let characterImageView = UIImageView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.text_Primary
        label.font = UIFont.spoqa(size: 14, family: .bold)
        label.sizeToFit()
        return label
    }()
    
    private let todoTotalCountLabel = UILabel().then {
        $0.textColor = Color.text_Teritary
        $0.font = UIFont.spoqa(size: 14, family: .regular)
        $0.sizeToFit()
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = Color.text_Primary
        $0.font = UIFont.spoqa(size: 14, family: .bold)
        $0.sizeToFit()
    }
    
    private let todoCountLabel = UILabel().then {
        $0.textColor = Color.text_Teritary
        $0.font = UIFont.spoqa(size: 14, family: .medium)
        $0.sizeToFit()
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
        stackView.isUserInteractionEnabled = false
    }

    func setData(historyTodoGroup: HistoryTodoGroup) {
        
        self.type = historyTodoGroup.type
        
        if historyTodoGroup.title == nil {
            // titleview 높이 줄이기 (높이값 괜찮은지 확인해보기)
            titleView.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: 8)
        } else {
            titleView.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: 32)
            
            switch historyTodoGroup.type {
                case .blue:
                    characterImageView.image = UIImage(named: "char2_blue_history")
                case .green:
                    characterImageView.image = UIImage(named: "char2_green_history")
                case .orange:
                    characterImageView.image = UIImage(named: "char2_orange_history")
                case .pink:
                    characterImageView.image = UIImage(named: "char2_pink_history")
            }

            titleLabel.text = historyTodoGroup.title
            todoTotalCountLabel.text = historyTodoGroup.todoTotalCount
        }

        dateLabel.text = historyTodoGroup.date  // 날짜 가공하기
        todoCountLabel.text = "\(historyTodoGroup.historyTodos.filter { $0.succeed == true }.count)/\(historyTodoGroup.historyTodos.count)"

        for todo in historyTodoGroup.historyTodos {
            addStackViewData(todo)
        }
    }
}

// MARK: - UI Layout & addSubview
extension HistoryCell {
    private func setLayout() {
        self.addSubviews(
            titleView,
            dateLabel,
            todoCountLabel,
            contextView)
        
        titleView.addSubviews(characterImageView,
                              titleLabel,
                              todoTotalCountLabel)
        
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
        
        todoTotalCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(characterImageView)
            $0.trailing.equalToSuperview().offset(-2)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(9)
            $0.leading.equalToSuperview()
        }
        
        todoCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(8)
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
extension HistoryCell {
    private func addStackViewData(_ todo: HistoryTodo) {
        let backView = UIView()
        
        let checkButtonImage = UIImageView().then {
            $0.backgroundColor = Color.Gray100
            
            if todo.succeed {
                guard let type = self.type else { return }
                switch type {
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
                $0.layer.borderWidth = 1.33
                $0.layer.borderColor = Color.Gray500.cgColor
            }
        }
        
        let todoTitleLabel = UILabel().then {
            $0.text = todo.name
            $0.font = UIFont.spoqa(size: 14, family: .regular)
            $0.textColor = .black
        }
        
        let view = UIView().then {
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 8
        }
        
        backView.addSubview(view)
        view.addSubviews(
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
        
        checkButtonImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(23.33)
            $0.centerY.equalToSuperview()
        }
        
        todoTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButtonImage.snp.trailing).offset(12)
            $0.centerY.equalTo(checkButtonImage)
            $0.trailing.equalToSuperview()
        }
    }
}
