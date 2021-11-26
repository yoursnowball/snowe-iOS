//
//  HistoryTodo.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/23.
//

import Foundation

struct HistoryTodoGroup {
    var type: Snowe
    var title: String?
    var date: String
    var todoTotalCount: String?
    var historyTodos: [HistoryTodo]
}

struct HistoryTodo {
    var name: String
    var succeed: Bool
    var goalId: Int? = nil
    var todoId: Int? = nil
}
