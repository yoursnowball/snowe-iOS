//
//  GetDailyGoalsResponse.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/29.
//

struct GetDailyGoalsResponse: Codable {
    let createdAt: String
    let id, level: Int
    let name, objective: String
    let todaySucceedTodoCount, todayTotalTodoCount: Int
    var todos: [TodoResponse]
    let type: String
}
