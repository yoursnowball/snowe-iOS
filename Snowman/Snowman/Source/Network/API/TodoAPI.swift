//
//  TodoAPI.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/24.
//

import Foundation
import Moya

enum TodoAPI {
    case postTodo(goalId: Int, date: String, todo: String)
    case putTodo(goalId: Int, todoId: Int, name: String, succeed: Bool)
    case deleteTodo(goalId: Int, todoId: Int)
}

extension TodoAPI: BaseTargetType {
    var path: String {
        switch self {
        case .postTodo(let goalId, _, _):
            return URLConst.goals + "/\(goalId)" + URLConst.todo
        case .putTodo(let goalId, let todoId, _, _):
            return URLConst.goals + "/\(goalId)" + URLConst.todo + "/\(todoId)"
        case .deleteTodo(let goalId, let todoId):
            return URLConst.goals + "/\(goalId)" + URLConst.todo + "/\(todoId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postTodo:
            return .post
        case .putTodo:
            return .put
        case .deleteTodo:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .postTodo(_, let date, let todo):
            return .requestParameters(parameters: [
                "date": date,
                "todo": todo
            ], encoding: JSONEncoding.default)
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
