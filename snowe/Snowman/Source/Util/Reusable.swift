//
//  Reusable.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/18.
//

import Foundation

protocol Reusable: AnyObject {
  static var reuseIdentifier: String { get }
}

extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
