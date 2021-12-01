//
//  GenericPageArrayResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

struct GenericPageArrayResponse<T: Codable>: Codable {
    let content: [T]
    let currentPage: Int
    let isLast: Bool
}
