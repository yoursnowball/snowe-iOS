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
    case getRank(page: Int)
}

extension AwardAPI: BaseTargetType {
    var path: String {
        switch self {
        case .getAwards:
            return URLConst.awards
        case .getRank:
            return URLConst.rank
        }
    }

    var method: Moya.Method {
        switch self {
        case .getAwards:
            return .get
        case .getRank:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getAwards:
            return .requestPlain
        case .getRank(let page):
            return .requestParameters(parameters: [
                "page": page
            ], encoding: URLEncoding.queryString)
        }
    }
}
