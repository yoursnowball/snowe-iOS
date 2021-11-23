//
//  Sequence+.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/24.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
