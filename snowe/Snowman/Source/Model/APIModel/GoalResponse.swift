//
//  GoalResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

struct GoalResponse: Codable {
    let createdAt: String
    let id, levelTodoCount: Int
    var level : Int
    let name, objective: String
    let succeedTodoCount: Int
    var todos: [TodoResponse]
    let type: String
}
