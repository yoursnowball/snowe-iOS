//
//  TodoService.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/24.
//

import Foundation
import Moya

final class TodoService {
    private let todoProvider = MoyaProvider<TodoAPI>(plugins: [MoyaLoggingPlugin()])

    public func putTodo(
        goalId: Int,
        todoId: Int,
        name: String,
        succeed: Bool,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        todoProvider.request(.putTodo(goalId: goalId, todoId: todoId, name: name, succeed: succeed)) { result in
            switch result {
            case.success(let response):

                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }

        }
    }

    public func deleteTodo(
        goalId: Int,
        todoId: Int,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        todoProvider.request(.deleteTodo(goalId: goalId, todoId: todoId)) { result in
            switch result {
            case .success(let response):

                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }

    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {

        let decoder = JSONDecoder()

        switch statusCode {
        case 200:
            guard let decodedData = try? decoder.decode(PutTodoResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case 204:
            // delete response 확인하기
            return .success(data)
        case 400..<500:
            guard let decodedData = try? decoder.decode(ErrorResponse.self, from: data) else {
                return .pathErr
            }
            return .requestErr(decodedData)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
