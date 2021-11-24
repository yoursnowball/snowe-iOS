//
//  TodayTodo.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/24.
//

import Foundation

struct TodayTodoGroup {
    var type: Snowe
    var title: String?
    var date: String
    var todoTotalCount: String?
    var historyTodos: [TodayTodo]
}

struct TodayTodo {
    var name: String
    var succeed: Bool
}
