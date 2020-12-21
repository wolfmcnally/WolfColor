//
//  ColorExtensions.swift
//  WolfColor
//
//  Created by Wolf McNally on 7/15/15.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
extension UIColor {
    public convenience init(_ color: Color) {
        self.init(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }

    public convenience init(string: String) throws {
        self.init(try Color(string: string))
    }

    public static func toColor(osColor: UIColor) -> Color {
        return CGColor.toColor(from: osColor.cgColor)
    }

    public func settingSaturation(saturation: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: saturation, brightness: b, alpha: a)
    }

    public func settingBrightness(brightness: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: brightness, alpha: a)
    }
}
#elseif canImport(AppKit)
extension NSColor {
    public convenience init(_ color: Color) {
        self.init(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }

    public convenience init(string: String) throws {
        self.init(try Color(string: string))
    }

    public static func toColor(osColor: NSColor) -> Color {
        return CGColor.toColor(from: osColor.cgColor)
    }

    public func settingSaturation(saturation: CGFloat) -> NSColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return NSColor(hue: h, saturation: saturation, brightness: b, alpha: a)
    }

    public func settingBrightness(brightness: CGFloat) -> NSColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return NSColor(hue: h, saturation: s, brightness: brightness, alpha: a)
    }
}
#endif

#if canImport(UIKit)
extension UIColor {
    public var debugSummary: String {
        return UIColor.toColor(osColor: self).debugSummary
    }
}
#elseif canImport(AppKit)
extension NSColor {
    public var debugSummary: String {
        return NSColor.toColor(osColor: self).debugSummary
    }
}
#endif

//extension OSColor {
//    public static func testInitFromString() {
//        do {
//            let strings = [
//                "#f80",
//                "#ff8000",
//                "0.1 0.5 1.0",
//                "0.1 0.5 1.0 0.5",
//                "r: 0.2 g: 0.4 b: 0.6",
//                "red: 0.3 green: 0.5 blue: 0.7",
//                "red: 0.3 green: 0.5 blue: 0.7 alpha: 0.5",
//                "h: 0.2 s: 0.8 b: 1.0",
//                "hue: 0.2 saturation: 0.8 brightness: 1.0",
//                "hue: 0.2 saturation: 0.8 brightness: 1.0 alpha: 0.5"
//                ]
//            for string in strings {
//                let color = try OSColor(string: string)
//                print("string: \(string), color: \(color)")
//            }
//        } catch let error {
//            logError(error)
//        }
//    }
//}

#if canImport(UIKit)
extension UIColor {
    public var luminance: Double {
        return Color(self).luminance
    }

    public func multiplied(by rhs: Double) -> UIColor {
        return UIColor(Color(self).multiplied(by: rhs))
    }

    public func added(to rhs: UIColor) -> UIColor {
        return UIColor(Color(self).added(to: Color(rhs)))
    }

    public func lightened(by frac: Double) -> UIColor {
        return UIColor(Color(self).lightened(by: frac))
    }

    public func darkened(by frac: Double) -> UIColor {
        return UIColor(Color(self).darkened(by: frac))
    }

    public func dodged(by frac: Double) -> UIColor {
        return UIColor(Color(self).dodged(by: frac))
    }

    public func burned(by frac: Double) -> UIColor {
        return UIColor(Color(self).burned(by: frac))
    }
}
#elseif canImport(AppKit)
extension NSColor {
    public var luminance: Double {
        return Color(self).luminance
    }

    public func multiplied(by rhs: Double) -> NSColor {
        return NSColor(Color(self).multiplied(by: rhs))
    }

    public func added(to rhs: NSColor) -> NSColor {
        return NSColor(Color(self).added(to: Color(rhs)))
    }

    public func lightened(by frac: Double) -> NSColor {
        return NSColor(Color(self).lightened(by: frac))
    }

    public func darkened(by frac: Double) -> NSColor {
        return NSColor(Color(self).darkened(by: frac))
    }

    public func dodged(by frac: Double) -> NSColor {
        return NSColor(Color(self).dodged(by: frac))
    }

    public func burned(by frac: Double) -> NSColor {
        return NSColor(Color(self).burned(by: frac))
    }
}
#endif

#if canImport(UIKit)
extension UIColor {
    public static func oneColor(_ color: UIColor) -> ColorFunc {
        return makeOneColor(Color(color))
    }

    public static func twoColor(_ color1: UIColor, _ color2: UIColor) -> ColorFunc {
        return makeTwoColor(Color(color1), Color(color2))
    }

    public static func threeColor(_ color1: UIColor, _ color2: UIColor, _ color3: UIColor) -> ColorFunc {
        return makeThreeColor(Color(color1), Color(color2), Color(color3))
    }
}
#elseif canImport(AppKit)
extension NSColor {
    public static func oneColor(_ color: NSColor) -> ColorFunc {
        return makeOneColor(Color(color))
    }

    public static func twoColor(_ color1: NSColor, _ color2: NSColor) -> ColorFunc {
        return makeTwoColor(Color(color1), Color(color2))
    }

    public static func threeColor(_ color1: NSColor, _ color2: NSColor, _ color3: NSColor) -> ColorFunc {
        return makeThreeColor(Color(color1), Color(color2), Color(color3))
    }
}
#endif

extension Color {
    public init(cgColor: CGColor) {
        switch cgColor.colorSpace!.model {
        case .monochrome:
            let c = cgColor.components!
            let white = Double(c[0])
            let alpha = Double(c[1])
            self.init(white: white, alpha: alpha)
        case CGColorSpaceModel.rgb:
            let c = cgColor.components!
            let red = Double(c[0])
            let green = Double(c[1])
            let blue = Double(c[2])
            let alpha = Double(c[3])
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        default:
            fatalError("unsupported color model")
        }
    }

    public static func toCGColor(from color: Color) -> CGColor {
        let red = CGFloat(color.red)
        let green = CGFloat(color.green)
        let blue = CGFloat(color.blue)
        let alpha = CGFloat(color.alpha)

        return CGColor(colorSpace: sharedColorSpaceRGB, components: [red, green, blue, alpha])!
    }
}

extension CGColor {
    public static func toColor(from cgColor: CGColor) -> Color {
        return Color(cgColor: cgColor)
    }
}

extension Color {
    #if canImport(UIKit)
    public init(_ color: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(red: Double(r), green: Double(g), blue: Double(b), alpha: Double(a))
    }
    #elseif canImport(AppKit)
    public init(_ color: NSColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(red: Double(r), green: Double(g), blue: Double(b), alpha: Double(a))
    }
    #endif
}

extension Color {
    #if canImport(UIKit)
    public var uiColor: UIColor {
        UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    #elseif canImport(AppKit)
    public var nsColor: NSColor {
        NSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    #endif
}

//    public class func diagonalStripesPattern(color1: OSColor, color2: OSColor, isFlipped: Bool = false) -> OSColor {
//        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 64, height: 64))
//        let image = newImage(withSize: bounds.size, isOpaque: true, scale: mainScreenScale, renderingMode: .alwaysOriginal) { context in
//            context.setFillColor(color1.cgColor)
//            context.fill(bounds)
//            let path = OSBezierPath()
//            if isFlipped {
//                path.addClosedPolygon(withPoints: [bounds.maxXmidY, bounds.maxXminY, bounds.midXminY])
//                path.addClosedPolygon(withPoints: [bounds.maxXmaxY, bounds.minXminY, bounds.minXmidY, bounds.midXmaxY])
//            } else {
//                path.addClosedPolygon(withPoints: [bounds.midXminY, bounds.minXminY, bounds.minXmidY])
//                path.addClosedPolygon(withPoints: [bounds.maxXminY, bounds.minXmaxY, bounds.midXmaxY, bounds.maxXmidY])
//            }
//            color2.set(); path.fill()
//        }
//        return OSColor(patternImage: image)
//    }
