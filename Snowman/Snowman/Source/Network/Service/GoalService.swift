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

    private enum ResponseData {
        case postNewGoal
        case getGoal
        case postAwards
        case getGoalsByDate
        case getGoalsForCalendar
    }

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

                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .postNewGoal)
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

                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getGoal)
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

    public func postAwards(
        goalId: Int,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        goalProvider.request(.postAwards(goalId: goalId)) { result in
            switch result {
            case .success(let response):

                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .postAwards)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }

    public func getGoalsByDate(
        date: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        goalProvider.request(.getGoalsByDate(date: date)) { result in
            switch result {
            case .success(let response):

                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getGoalsByDate)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }

        }
    }

    public func getGoalsForCalendar(
        start: String,
        end: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        goalProvider.request(.getGoalsForCalendar(start: start, end: end)) { result in
            switch result {
            case .success(let response):

                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getGoalsForCalendar)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }

    private func judgeStatus(by statusCode: Int, _ data: Data, responseData: ResponseData) -> NetworkResult<Any> {
        let decoder = JSONDecoder()

        switch statusCode {
        case 200..<300:
            switch responseData {
            case .postNewGoal, .getGoal, .postAwards, .getGoalsByDate, .getGoalsForCalendar:
                return isValidData(data: data, responseData: responseData)
            }
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

    private func isValidData(data: Data, responseData: ResponseData) -> NetworkResult<Any> {
        let decoder = JSONDecoder()

        switch responseData {
        case .postNewGoal, .getGoal:
            guard let decodedData = try? decoder.decode(GoalResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .postAwards:
            guard let decodedData = try? decoder.decode(Award.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .getGoalsByDate:
            guard let decodedData = try? decoder.decode(GetGoalsByDateResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .getGoalsForCalendar:
            guard let decodedData = try? decoder.decode(GetGoalsForCalendarResponse.self, from: data) else {
                return .pathErr
            }
            
            
//            let decodedData = try! decoder.decode(GetGoalsForCalendarResponse.self, from: data)
            
            
            return .success(decodedData)
        }
    }
}
