//
//  SnoweCollectionViewCell.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import UIKit

class SnoweCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
