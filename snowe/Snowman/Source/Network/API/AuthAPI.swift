//
//  AuthAPI.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/22.
//

import Foundation
import Moya

enum AuthAPI {
    case postSignIn(password: String, userName: String)
    case postSignUp(nickName: String, password: String, userName: String)
}

extension AuthAPI: BaseTargetType {
    var path: String {
        switch self {
        case .postSignIn:
            return URLConst.signIn
        case .postSignUp:
            return URLConst.signUp
        }
    }

    var method: Moya.Method {
        switch self {
        case .postSignIn, .postSignUp:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .postSignIn(let password, let userName):
            return .requestParameters(parameters: [
                                        "password": password,
                                        "userName": userName
            ], encoding: JSONEncoding.default)
        case .postSignUp(let nickName, let password, let userName):
            return .requestParameters(parameters: [
                "nickName": nickName,
                "password": password,
                "userName": userName
            ], encoding: JSONEncoding.default)
        }
    }
}
