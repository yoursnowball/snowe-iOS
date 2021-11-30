//
//  GetGoalsByDateResponse.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/28.
//

struct GetGoalsByDateResponse: Codable {
    let goals: [GetDailyGoalsResponse]
}
