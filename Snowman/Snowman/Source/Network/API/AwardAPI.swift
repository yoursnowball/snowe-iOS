//
//  AwardAPI.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import Foundation
import Moya

enum AwardAPI {
    case getAwards
}

extension AwardAPI: BaseTargetType {
    var path: String {
        switch self {
        case .getAwards:
            return URLConst.awards
        }
    }

    var method: Moya.Method {
        switch self {
        case .getAwards:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getAwards:
            return .requestPlain
        }
    }
}
