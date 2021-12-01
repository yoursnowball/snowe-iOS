//
//  TodoModel.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/21.
//

import Foundation

struct TodoListGroup {
    let title: String
    var totalTodoCount: Int
    var doneTodoCount: Int
    var characterType: CharacterType
    var todoList: [TodoList]
}

struct TodoList {
    var title: String
    var isDone: Bool
    var characterType: CharacterType
}

enum CharacterType {
    case blue
    case green
    case orange
    case pink
}
