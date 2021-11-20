//
//  BaseTargetType.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {

    var baseURL: URL {
        return URL(string: URLConst.base)!
    }

    var headers: [String: String]? {
        let token = UserDefaults.standard.value(forKey: UserDefaultKey.token)
        let header = [
            "Content-Type": "application/json",
            "Authentication": "Bearer \(String(describing: token))"
        ]
        return header
    }

    var sampleData: Data {
        return Data()
    }

}
