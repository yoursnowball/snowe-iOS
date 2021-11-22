//
//  UserResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/22.
//

struct UserResponse: Codable {
    let createdAt: String
    let goalCount: Int
    let goals: [GoalResponse]
    let nickName: String
}
