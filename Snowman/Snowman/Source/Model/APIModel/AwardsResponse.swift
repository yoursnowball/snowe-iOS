//
//  AwardsResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

struct AwardsResponse: Codable {
    let awards: [Award]
}

struct Award: Codable {
    let awardAt, createdAt: String
    let id, level: Int
    let name: String
    let succeedTodoCount, totalTodoCount: Int
    let type: String
}
