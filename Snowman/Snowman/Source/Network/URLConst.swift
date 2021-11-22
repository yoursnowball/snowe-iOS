//
//  URLConst.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

enum URLConst {
    // MARK: - baseURL
    static let base = "http://3.36.118.6:8080"

    // MARK: - Goal
    static let goals = "/goals"

    // MARK: - Awards
    /// 명예의 전당 리스트 가져오기
    static let awards = "/awards"

    /// 명예의 전당 랭킹 가져오기
    static let rank = awards + "/rank"
}
