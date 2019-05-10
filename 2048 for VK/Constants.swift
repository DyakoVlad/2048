//
//  Constants.swift
//  2048 for VK
//
//  Created by Влад Дьяков on 10/05/2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit

extension UIColor {
    static func by(r: Int, g: Int, b: Int, a: CGFloat = 1) -> UIColor {
        let d = CGFloat(255)
        return UIColor(red: CGFloat(r) / d, green: CGFloat(g) / d, blue: CGFloat(b) / d, alpha: a)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static let clear = UIColor(rgb: 0xB8C1CC)
    static let colour2 = UIColor(rgb: 0xffffff)
    static let colour4 = UIColor(rgb: 0xe1e3e6)
    static let colour8 = UIColor(rgb: 0x99ddff)
    static let colour16 = UIColor(rgb: 0x5cb3ff)
    static let colour32 = UIColor(rgb: 0x1c8aeb)
    static let colour64 = UIColor(rgb: 0x0064d6)
    static let colour128 = UIColor(rgb: 0x0049b8)
    static let colour256 = UIColor(rgb: 0x1b3e85)
    static let colour512 = UIColor(rgb: 0x0b2b85)
    static let colour1024 = UIColor(rgb: 0x0018b8)
    static let colour2048 = UIColor(rgb: 0x110570)
    
}
