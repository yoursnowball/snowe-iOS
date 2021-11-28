//
//  StampResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/28.
//

import Foundation

struct StampData: Codable {
    let badges: [Stamp]

}

struct Stamp: Codable {
    let id: Int
    let name, info: String
    let hasBadge: Bool

}
