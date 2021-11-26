//
//  TodoAPI.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/24.
//

import Foundation
import Moya

enum TodoAPI {
//    case postTodo(goalId: Int, date: String, )
    case putTodo(goalId: Int, todoId: Int, name: String, succeed: Bool)
    case deleteTodo(goalId: Int, todoId: Int)
}

extension TodoAPI: BaseTargetType {
    var path: String {
        switch self {
        case .putTodo(let goadId, let todoId, _, _):
            return URLConst.goals + "/\(goadId)" + URLConst.todo + "/\(todoId)"
        case .deleteTodo(let goalId, let todoId):
            return URLConst.goals + "/\(goalId)" + URLConst.todo + "/\(todoId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .putTodo:
            return .put
        case .deleteTodo:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .putTodo(_, _, let name, let succeed):
            return .requestParameters(parameters: [
                "name": name,
                "succeed": succeed
            ], encoding: JSONEncoding.default)
        case .deleteTodo:
            return .requestPlain
        }
    }
}
