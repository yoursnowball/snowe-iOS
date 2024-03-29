//
//  URLConst.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

enum URLConst {
    // MARK: - baseURL
    static let base = "https://snowe.ml"

    // MARK: - Goal
    static let goals = "/goals"
    static let calendar = "/calendar"

    // MARK: - Awards
    /// 명예의 전당 리스트 가져오기
    static let awards = "/awards"

    /// 명예의 전당 랭킹 가져오기
    static let rank = awards + "/rank"

    // MARK: - Auth
    /// 로그인
    static let signIn = "/auth/sign-in"

    /// 회원가입
    static let signUp = "/auth/sign-up"

    // MARK: - Todo
    /// 투두
    static let todo = "/todos"

    // MARK: - User
    /// 내 정보 가져오기 - 홈
    static let users = "/users"

    /// 알람 목록
    static let alarms = users + "/alarms"

    /// fcm Token
    static let fcm = users + "/token"
}
