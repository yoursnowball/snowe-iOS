//
//  PutTodoResponse.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/24.
//

struct PutTodoResponse: Codable {
    let levelChange: String
    let todo: TodoResponse
}
