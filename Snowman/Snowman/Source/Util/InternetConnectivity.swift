//
//  InternetConnectivity.swift
//  Snowman
//
//  Created by Yonghyun on 2021/11/28.
//

import Alamofire
import Foundation

struct InternetConnectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet: Bool {
        return sharedInstance.isReachable
    }
}
