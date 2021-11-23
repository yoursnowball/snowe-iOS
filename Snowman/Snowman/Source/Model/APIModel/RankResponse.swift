//
//  RankResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

struct RankResponse: Codable {
    let content: [RankUserInfo]
    let currentPage: Int
    let isLast: Bool
}

struct RankUserInfo: Codable {
    let awardAt, createdAt: String
    let id, level: Int
    let name, objective: String
    let succeedTodoCount, totalTodoCount: Int
    let type, userName: String
}
