//
//  StampResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/28.
//

import Foundation

struct StampResponse: Codable {
    let stamps: [Stamp]

}

struct Stamp: Codable {
    let id: Int
    let name, info: String
    let hasStamp: Bool
}
