//
//  AlarmsResponse.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

struct AlarmsResponse: Codable {
    let alarms: [Alarm]
}

struct Alarm: Codable {
    let alarmAt, body: String
    let id: Int
    let status, title: String
}
