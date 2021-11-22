//
//  AuthService.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/22.
//

import Foundation
import Moya

final class AuthService {
    private let authProvider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])

    public func postSignIn(password: String,
                           userName: String,
                           completion: @escaping (NetworkResult<Any>) -> Void) {
        authProvider.request(.postSignIn(password: password, userName: userName)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let error):
                print(error)
            }
        }
    }

    public func postSignUp(nickName: String,
                           password: String,
                           userName: String,
                           completion: @escaping (NetworkResult<Any>) -> Void) {
        authProvider.request(.postSignUp(nickName: nickName, password: password, userName: userName)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let error):
                print(error)
            }
        }
    }

    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {

        let decoder = JSONDecoder()

        switch statusCode {
        case 200:
            guard let decodedData = try? decoder.decode(AuthResponse.self, from: data) else {
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
