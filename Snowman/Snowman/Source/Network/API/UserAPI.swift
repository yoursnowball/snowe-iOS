//
//  UserAPI.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

import Foundation
import Moya

enum UserAPI {
    case getUsers
    case getAlarms
    case postPushToken(token: String)
}

extension UserAPI: BaseTargetType {
    var path: String {
        switch self {
        case .getUsers:
            return URLConst.users
        case .getAlarms:
            return URLConst.alarms
        case .postPushToken:
            return URLConst.fcm
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUsers, .getAlarms:
            return .get
        case .postPushToken:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .getUsers, .getAlarms:
            return .requestPlain
        case .postPushToken(let token):
            return .requestParameters(parameters: [
                "token": token
            ], encoding: JSONEncoding.default)
        }
    }
}
