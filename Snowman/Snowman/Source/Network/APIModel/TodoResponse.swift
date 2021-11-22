//
//  TodoResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

struct TodoResponse: Codable {
    let createdAt, finishedAt: String
    let id: Int
    let name: String
    let succeed: Bool
}
