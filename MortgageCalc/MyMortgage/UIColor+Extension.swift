//
//  UIColor+Extension.swift
//  MyMortgage
//
//  Created by Priya on 17/01/2017.
//  Copyright © 2017 Dunlysis. All rights reserved.
//

import UIKit

extension UIColor {
    
    var themeBackgroundColor:UIColor { // very light white-grey
        get {
            return UIColor.hexStringToUIColor(hex: "#fcfcfc")
        }
    }
    
    var borderColor:UIColor { // light grey color
        get {
            return UIColor.hexStringToUIColor(hex: "#dedede")
        }
    }

    var columnColor:UIColor { // light grey color than borderColor
        get {
            return UIColor.hexStringToUIColor(hex: "#f6f6f6")
        }
    }

    var primaryTextColor:UIColor { // black color
        get {
            return UIColor.black
        }
    }
    
    var primaryBackgroundColor:UIColor { // white color
        get {
            return UIColor.white
        }
    }
    
    //var color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF) - IMPLEMENTATION EXAMPLE
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    //var color2 = UIColor(netHex:0xFFFFFF) - IMPLEMENTATION EXAMPLE
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
//    let darkGrey = UIColor(hexString: "#757575")  - IMPLEMENTATION EXAMPLE
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    //var color1 = hexStringToUIColor("#d3d3d3") - IMPLEMENTATION EXAMPLE
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
//    class func themeBackgroundColor() -> UIColor { // very light white-grey
//        return hexStringToUIColor(hex: "#fcfcfc")
//    }
//    
//    class func borderColor() -> UIColor { // light grey color
//        return hexStringToUIColor(hex: "#dedede")
//    }

}
