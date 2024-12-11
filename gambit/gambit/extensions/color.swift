//
//  color.swift
//  node
//
//  Created by Nick Mantini on 10/28/24.
//

import SwiftUICore
import UIKit

public extension Color {
    static func randomColor() -> Color {
        func randomComponent() -> CGFloat {
            var component: CGFloat = 0.0
            while component < 0.1 || component > 0.84 {
                component = CGFloat(drand48())
            }
            return component
        }
        
        let red = randomComponent()
        let green = randomComponent()
        let blue = randomComponent()
        
        return Color(red: red, green: green, blue: blue)
    }
    
    init?(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 1.0

            let length = hexSanitized.count

            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

            if length == 6 {
                r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
                g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
                b = CGFloat(rgb & 0x0000FF) / 255.0

            } else if length == 8 {
                r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
                g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
                b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
                a = CGFloat(rgb & 0x000000FF) / 255.0

            } else {
                return nil
            }

            self.init(red: r, green: g, blue: b, opacity: a)
        }
    
    func toHex() -> String? {
            let uic = UIColor(self)
            guard let components = uic.cgColor.components, components.count >= 3 else {
                return nil
            }
            let r = Float(components[0])
            let g = Float(components[1])
            let b = Float(components[2])
            var a = Float(1.0)

            if components.count >= 4 {
                a = Float(components[3])
            }

            if a != Float(1.0) {
                return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
            } else {
                return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
            }
        }
}
