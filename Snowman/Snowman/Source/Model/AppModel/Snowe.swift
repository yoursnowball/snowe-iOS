//
//  Snowe.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//
import UIKit.UIImage

enum Snowe: String {
    case pink = "PINK"
    case orange = "ORANGE"
    case green = "GREEN"
    case blue = "BLUE"

    var index: Int {
        switch self {
        case .pink:
            return 0
        case .orange:
            return 1
        case .green:
            return 2
        case .blue:
            return 3
        }
    }

    var color: UIColor {
        switch self {
        case .pink:
            return .systemPink
        case .orange:
            return .systemOrange
        case .green:
            return .systemGreen
        case .blue:
            return .systemBlue
        }
    }

    var doneText: String {
        var text = "오늘의 투두를 완료했어요"
        switch self {
        case .pink:
            text += "💗"
        case .orange:
            text += "💛"
        case .green:
            text += "💚"
        case .blue:
            text += "💙"
        }
        return text
    }

    func getImage(level: Int) -> UIImage {
        // TODO:- 단계별 캐릭터 확정되면 구현

        // 0 - 목표 생성시 카드뷰
        switch self {
        case .pink:
            return Image.pinkCard
        case .orange:
            return Image.orangeCard
        case .green:
            return Image.greenCard
        case .blue:
            return Image.blueCard
        }
    }

    static func getType(with index: Int) -> Snowe {
        switch index {
        case 0:
            return .pink
        case 1:
            return .orange
        case 2:
            return .green
        case 3:
            return .blue
        default:
            print("index 값은 0~3 사이로")
            return .pink
        }
    }
}
