//
//  AlarmsResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

struct AlarmResponse: Codable {
    let alarmAt, body: String
    let id: Int
    let status, title: String
}
