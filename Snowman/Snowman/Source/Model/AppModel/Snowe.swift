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

    // swiftlint:disable cyclomatic_complexity
    func getImage(level: Int) -> UIImage {
        switch level {
            // 0 - 목표 생성시 카드뷰
        case 0:
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
        case 1, 2, 3, 4:
            switch self {
            case .pink:
                return UIImage(named: "char\(level)_pink")!
            case .orange:
                return UIImage(named: "char\(level)_orange")!
            case .green:
                return UIImage(named: "char\(level)_green")!
            case .blue:
                return UIImage(named: "char\(level)_blue")!
            }
        default:
            switch self {
            case .pink:
                return UIImage(named: "char5_pink")!
            case .orange:
                return UIImage(named: "char5_orange")!
            case .green:
                return UIImage(named: "char5_green")!
            case .blue:
                return UIImage(named: "char5_blue")!
            }

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
