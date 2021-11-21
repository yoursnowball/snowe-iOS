//
//  ErrorResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

struct ErrorResponse: Codable {
    let timestamp: String
    let status: Int
    let error, message, path: String
}
