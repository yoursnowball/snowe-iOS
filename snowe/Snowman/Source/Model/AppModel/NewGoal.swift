//
//  NewGoal.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/21.
//

struct NewGoal {
    static var shared = NewGoal()

    public var name: String?
    public var type: Snowe?
    public var objective: String?

    public func makeNewGoal() -> GoalRequest? {
        guard let name = name else { return nil}
        guard let type = type else { return nil}
        guard let objective = objective else {
            return nil}

        return GoalRequest(name: name, type: type.rawValue, objective: objective)
    }
}
