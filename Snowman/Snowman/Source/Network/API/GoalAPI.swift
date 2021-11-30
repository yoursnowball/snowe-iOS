//
//  GoalAPI.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//

import Foundation
import Moya

enum GoalAPI {
    case postNewGoal(name: String, type: String, objective: String)
    case getGoal(goalId: Int, date: String? = nil)
    case deleteGoal(goalId: Int)
    case postAwards(goalId: Int)
    case getGoalsByDate(date: String)
    case getGoalsForCalendar(start: String, end: String)
}

extension GoalAPI: BaseTargetType {
    var path: String {
        switch self {
        case .postNewGoal:
            return URLConst.goals
        case .getGoal(let goalId, _):
            return URLConst.goals + "/\(goalId)"
        case .deleteGoal(let goalId):
            return URLConst.goals + "/\(goalId)"
        case .postAwards(let goalId):
            return URLConst.goals + "/\(goalId)" + URLConst.awards
        case .getGoalsByDate:
            return URLConst.goals
        case .getGoalsForCalendar:
            return URLConst.goals + URLConst.calendar
        }
    }

    var method: Moya.Method {
        switch self {
        case .postNewGoal:
            return .post
        case .getGoal:
            return .get
        case .deleteGoal:
            return .delete
        case .postAwards:
            return .post
        case .getGoalsByDate:
            return .get
        case .getGoalsForCalendar:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .postNewGoal(let name, let type, let objective):
            return .requestParameters(parameters: [
                "name": name,
                "type": type,
                "objective": objective
            ], encoding: JSONEncoding.default)
        case .getGoal(_, let date):
            if let date = date {
                return .requestParameters(parameters: [
                    "date": date
                ], encoding: URLEncoding.default)
            } else {
                return .requestPlain
            }
        case .deleteGoal:
            return .requestPlain
        case .postAwards:
            return .requestPlain
        case .getGoalsByDate(let date):
            return .requestParameters(parameters: [
                "date": date
            ], encoding: URLEncoding.default)
        case .getGoalsForCalendar(let start, let end):
            return .requestParameters(parameters: [
                "start": start,
                "end": end
            ], encoding: URLEncoding.default)

        }
    }
}
