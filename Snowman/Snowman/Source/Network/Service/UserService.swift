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

    public func getUsers(
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {

        goalProvider.request(.getUsers) { result in
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

    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {

        let decoder = JSONDecoder()

        switch statusCode {
        case 200:
            guard let decodedData = try? decoder.decode(UserResponse.self, from: data) else {
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
