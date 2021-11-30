//
//  GetGoalsForCalendarResponse.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/29.
//

struct GetGoalsForCalendarResponse: Codable {
//    let goals: [GoalSummary]
    let goals: Dictionary<String, GoalSummary>
}

struct GoalSummary: Codable {
    let createdAt: String
    let id: Int
    var level: Int
    let name, objective: String
    let succeedTodoCount: Int
    let type: String
}
