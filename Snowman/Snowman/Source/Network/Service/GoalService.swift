//
//  GoalService.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

import Foundation
import Moya

final class GoalService {
    private let goalProvider = MoyaProvider<GoalAPI>(plugins: [MoyaLoggingPlugin()])

    public func postNewGoal(
        name: String,
        type: String,
        objective: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {

        goalProvider.request(.postNewGoal(name: name, type: type, objective: objective)) { result in
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

    public func getGoal(goalId: Int,
                        date: String? = nil,
                        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        goalProvider.request(.getGoal(goalId: goalId, date: date)) { result in
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

    public func deleteGoal(
        goalId: Int,
        completion: @escaping (Int) -> Void
    ) {
        goalProvider.request(.deleteGoal(goalId: goalId)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                completion(statusCode)
            case .failure(let err):
                print(err)
            }
        }
    }

    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()

        switch statusCode {
        case 200..<300:
            guard let decodedData = try? decoder.decode(GoalResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
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
