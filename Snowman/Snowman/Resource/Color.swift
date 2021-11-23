//
//  Color.swift
//  Snowman
//
//  Created by 김윤서 on 2021/11/14.
//

import UIKit.UIColor

enum Color {
    static var bg_blue: UIColor {
        return UIColor(hex: "#EBF7FF")
    }
    
    static var bg_orange: UIColor {
        return UIColor(hex: "#FFF1DE")
    }
    
    static var bg_pink: UIColor {
        return UIColor(hex: "#FFF1F5")
    }
    
    static var bg_green: UIColor {
        return UIColor(hex: "#ECFEEC")
    }
    
    static var button_blue: UIColor {
        return UIColor(hex: "#75BFF8")
    }
    
    static var text_Primary: UIColor {
        return UIColor(hex: "#2C2C2C")
    }
    
    static var text_Secondary: UIColor {
        return UIColor(hex: "#808080")
    }
    
    static var text_Teritary: UIColor {
        return UIColor(hex: "#B5B5B5")
    }
    
    static var Gray500: UIColor {
        return UIColor(hex: "#D4D4D4")
    }
    
    static var Gray300: UIColor {
        return UIColor(hex: "#F6F6F6")
    }
    
    static var Gray100: UIColor {
        return UIColor(hex: "#E5E5E5")
    }
    
    static var Gray000: UIColor {
        return UIColor(hex: "#FFFFFF")
    }
    
    static var line_blue: UIColor {
        return UIColor(hex: "#2699E2")
    }
    
    static var todo_blue: UIColor {
        return UIColor(hex: "#9FD3F3")
    }
    
    static var pinbg_blue: UIColor {
        return UIColor(hex: "#C0E7FF")
    }
    
    static var line_orange: UIColor {
        return UIColor(hex: "#FF9C19")
    }
    
    static var todo_orange: UIColor {
        return UIColor(hex: "#FEC57A")
    }
    
    static var pinbg_orange: UIColor {
        return UIColor(hex: "#FFD49C")
    }
    
    static var line_pink: UIColor {
        return UIColor(hex: "#FF6C98")
    }
    
    static var todo_pink: UIColor {
        return UIColor(hex: "#FFA9C3")
    }
    
    static var pinbg_pink: UIColor {
        return UIColor(hex: "#FFCADA")
    }
    
    static var line_green: UIColor {
        return UIColor(hex: "#4CD88B")
    }
    
    static var todo_green: UIColor {
        return UIColor(hex: "#8CE7BE")
    }
    
    static var pinbg_green: UIColor {
        return UIColor(hex: "#AEF2D3")
    }
}

fileprivate extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
