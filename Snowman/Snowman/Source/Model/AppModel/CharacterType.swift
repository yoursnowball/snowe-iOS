//
//  CharacterType.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/20.
//
import UIKit.UIImage

enum CharacterType: String {
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
        //TODO: - 색상 적용
        return .systemBlue
    }

    func getImage(level: Int) -> UIImage {
        //TODO:- 단계별 캐릭터 확정되면 구현
        return Image.sampleSnowe
    }

    static func getType(with index: Int) -> CharacterType {
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
