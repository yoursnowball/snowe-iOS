//
//  TodoResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

struct TodoResponse: Codable {
    let createdAt, finishedAt: String
    let id: Int
    var name: String
    var succeed: Bool
    let todoDate: String
}
