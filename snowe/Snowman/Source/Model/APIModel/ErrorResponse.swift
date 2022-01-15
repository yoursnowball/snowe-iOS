//
//  ErrorResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

struct ErrorResponse: Codable {
    let timeStamp: String
    let status: Int
    let message: String
    let path, code, error: String?
}
