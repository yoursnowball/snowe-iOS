//
//  AwardService.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

import Foundation
import Moya

final class AwardService {
    private let awardProvider = MoyaProvider<AwardAPI>(plugins: [MoyaLoggingPlugin()])

    private enum ResponseData {
        case getAwards
        case getRank
    }

    public func getAwards(
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        awardProvider.request(.getAwards) { result in
            switch result {
            case.success(let response):

                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getAwards)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }

    public func getRank(
        page: Int,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        awardProvider.request(.getRank(page: page)) { result in
            switch result {
            case.success(let response):

                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getRank)
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
            case .getAwards, .getRank:
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
        case .getAwards:
            guard let decodedData = try? decoder.decode(AwardsResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .getRank:
            guard let decodedData = try? decoder.decode(RankResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        }
    }

}
