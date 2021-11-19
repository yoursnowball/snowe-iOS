//
//  CharacterChoiceViewController.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/19.
//

import UIKit

class CharacterChoiceViewController: BaseViewController {

    private let numberLabel = UILabel().then {
        $0.font = .spoqa(size: 16, family: .bold)
        $0.text = "2/3"
    }

    private let questionLabel = UILabel().then {
        $0.text = "원하는 눈덩이를 선택해주세요"
        $0.font = .spoqa(size: 22, family: .medium)
    }

    private lazy var nextButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.systemBlue, for: .normal)
        $0.setBackgroundColor(.lightGray, for: .disabled)
        $0.titleLabel?.font = .spoqa(size: 18, family: .bold)
        $0.addTarget(self, action: #selector(nextButtonDidTapped(_:)), for: .touchUpInside)

        $0.snp.makeConstraints {
            $0.height.equalTo(53)
        }

        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10

        $0.isEnabled = false
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: CharacterCollectionViewCell.self)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }
}

extension CharacterChoiceViewController {
    @objc
    public func nextButtonDidTapped(_ sender: UIButton) {
        navigationController?.pushViewController(NameQuestionViewController(), animated: true)
    }
}

extension CharacterChoiceViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let cell: CharacterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        cell.isSelected = true
        nextButton.isEnabled  = true
    }
}

extension CharacterChoiceViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 4
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: CharacterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setCharacterImage(with: "person.fill")
        return cell
    }
}

extension CharacterChoiceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {

        let width = UIScreen.main.bounds.width

        let cellWidth = width * (240/375)
        let cellHeight = cellWidth * (400/240)

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
    -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 27
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

extension CharacterChoiceViewController {
    private func setLayouts() {
        setViewHierachies()
        setConstraints()
    }

    private func setViewHierachies() {
        view.addSubviews(
            numberLabel,
            questionLabel,
            collectionView,
            nextButton
        )
    }

    private func setConstraints() {
        numberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(13)
            $0.height.equalTo(19)
        }

        questionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(numberLabel.snp.bottom).offset(8)
            $0.height.equalTo(26)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width/375 * 400)
        }

        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }

    }
}
