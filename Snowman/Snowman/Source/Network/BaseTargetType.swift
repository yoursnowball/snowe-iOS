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
        if let token = UserDefaults.standard.value(forKey: UserDefaultKey.token) {
            let header = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(String(describing: token))"
            ]
            return header
        } else {
            let header = [
                "Content-Type": "application/json"
            ]
            return header
        }
    }

    var sampleData: Data {
        return Data()
    }

}
