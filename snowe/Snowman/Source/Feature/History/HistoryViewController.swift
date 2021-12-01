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

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension HistoryViewController {
    private func setLayout() {

        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            imageView)
    }
}
