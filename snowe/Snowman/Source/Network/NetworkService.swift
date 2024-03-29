//
//  NetworkService.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

final class NetworkService {
    static let shared = NetworkService()

    private init() { }

    let goal = GoalService()

    let award = AwardService()

    let auth = AuthService()

    let user = UserService()

    let todo = TodoService()
}
