//
//  PutTodoResponse.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/24.
//

struct PutTodoResponse: Codable {
    let isLevelUp: String
    let todo: Todo
}

struct Todo: Codable {
    let createdAt: String
    let finishedAt: String
    let id: Int
    let name: String
    let succeed: Bool
    let todoDate: String
}
