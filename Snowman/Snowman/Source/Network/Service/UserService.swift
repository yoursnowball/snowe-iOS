//
//  UserService.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/23.
//

import Foundation
import Moya

final class UserService {
    private let goalProvider = MoyaProvider<UserAPI>(plugins: [MoyaLoggingPlugin()])

    private enum ResponseData {
        case getUsers
        case getAlarmList
        case postFCMToken
    }

    public func getUsers(
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {

        goalProvider.request(.getUsers) { result in
            switch result {
            case.success(let response):

                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getUsers)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }

        }
    }

    public func getAlarmList(
        page: Int,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        goalProvider.request(.getAlarms(page: page)) { result in
            switch result {
            case.success(let response):

                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getAlarmList)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }

    public func postFCMToken(
        fcm: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        goalProvider.request(.postPushToken(token: fcm)) { result in
            switch result {
            case.success(let response):

                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .postFCMToken)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }

    private func judgeStatus(by statusCode: Int, _ data: Data, responseData: ResponseData) -> NetworkResult<Any> {
        switch statusCode {
        case 200:
            switch responseData {
            case .getUsers, .getAlarmList, .postFCMToken:
                return isValidData(data: data, responseData: responseData)
            }
        case 400..<500:
            return .requestErr(data)
        case 500:
            print(data)
            return .serverErr
        default:
            return .networkFail
        }
    }

    private func isValidData(data: Data, responseData: ResponseData) -> NetworkResult<Any> {
        let decoder = JSONDecoder()

        switch responseData {
        case .getUsers:
            guard let decodedData = try? decoder.decode(UserResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .getAlarmList:
            guard let decodedData = try? decoder.decode(GenericPageArrayResponse<AlarmResponse>.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .postFCMToken:
            guard let decodedData = try? decoder.decode(String.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        }
    }
}
