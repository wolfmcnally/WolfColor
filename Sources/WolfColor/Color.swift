//
//  Color.swift
//  WolfColor
//
//  Created by Wolf McNally on 1/10/16.
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

import Foundation
import Interpolate

#if canImport(Glibc)
    import Glibc
#endif

// rgb
// #rgb
//
// ^\s*#?(?<r>[[:xdigit:]])(?<g>[[:xdigit:]])(?<b>[[:xdigit:]])\s*$
private let singleHexColorRegex = try! NSRegularExpression(pattern: "^\\s*#?(?<r>[[:xdigit:]])(?<g>[[:xdigit:]])(?<b>[[:xdigit:]])\\s*$")

// rrggbb
// #rrggbb
//
// ^\s*#?(?<r>[[:xdigit:]]{2})(?<g>[[:xdigit:]]{2})(?<b>[[:xdigit:]]{2})\s*$
private let doubleHexColorRegex = try! NSRegularExpression(pattern: "^\\s*#?(?<r>[[:xdigit:]]{2})(?<g>[[:xdigit:]]{2})(?<b>[[:xdigit:]]{2})\\s*$")

// 1 0 0
// 1 0 0 1
// 1.0 0.0 0.0
// 1.0 0.0 0.0 1.0
// .2 .3 .4 .5
//
// ^\s*(?<r>\d*(?:\.\d+)?)\s+(?<g>\d*(?:\.\d+)?)\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?<a>\d*(?:\.\d+)?))?\s*$
private let floatColorRegex = try! NSRegularExpression(pattern: "^\\s*(?<r>\\d*(?:\\.\\d+)?)\\s+(?<g>\\d*(?:\\.\\d+)?)\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?<a>\\d*(?:\\.\\d+)?))?\\s*$")

// r: .1 g: 0.512 b: 0.9
// r: .1 g: 0.512 b: 0.9 a: 1
// red: .1 green: 0.512 blue: 0.9
// red: .1 green: 0.512 blue: 0.9 alpha: 1
//
// ^\s*(?:r(?:ed)?):\s+(?<r>\d*(?:\.\d+)?)\s+(?:g(?:reen)?):\s+(?<g>\d*(?:\.\d+)?)\s+(?:b(?:lue)?):\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?:a(?:lpha)?):\s+(?<a>\d*(?:\.\d+)?))?
private let labeledColorRegex = try! NSRegularExpression(pattern: "^\\s*(?:r(?:ed)?):\\s+(?<r>\\d*(?:\\.\\d+)?)\\s+(?:g(?:reen)?):\\s+(?<g>\\d*(?:\\.\\d+)?)\\s+(?:b(?:lue)?):\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?:a(?:lpha)?):\\s+(?<a>\\d*(?:\\.\\d+)?))?")

// h: .1 s: 0.512 b: 0.9
// hue: .1 saturation: 0.512 brightness: 0.9
// h: .1 s: 0.512 b: 0.9 alpha: 1
// hue: .1 saturation: 0.512 brightness: 0.9 alpha: 1.0
//
// ^\s*(?:h(?:ue)?):\s+(?<h>\d*(?:\.\d+)?)\s+(?:s(?:aturation)?):\s+(?<s>\d*(?:\.\d+)?)\s+(?:b(?:rightness)?):\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?:a(?:lpha)?):\s+(?<a>\d*(?:\.\d+)?))?
private let labeledHSBColorRegex = try! NSRegularExpression(pattern: "^\\s*(?:h(?:ue)?):\\s+(?<h>\\d*(?:\\.\\d+)?)\\s+(?:s(?:aturation)?):\\s+(?<s>\\d*(?:\\.\\d+)?)\\s+(?:b(?:rightness)?):\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?:a(?:lpha)?):\\s+(?<a>\\d*(?:\\.\\d+)?))?")

public struct Color: Codable {
    public var c: SIMD4<Double>

    @inlinable public var red: Double {
        get { return c[0] }
        set { c[0] = newValue }
    }

    @inlinable public var green: Double {
        get { return c[1] }
        set { c[1] = newValue }
    }

    @inlinable public var blue: Double {
        get { return c[2] }
        set { c[2] = newValue }
    }

    @inlinable public var alpha: Double {
        get { return c[3] }
        set { c[3] = newValue }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(red)
        try container.encode(green)
        try container.encode(blue)
        try container.encode(alpha)
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let red = try container.decode(Double.self)
        let green = try container.decode(Double.self)
        let blue = try container.decode(Double.self)
        let alpha = try container.decode(Double.self)
        c = [red, green, blue, alpha]
    }

    @inlinable public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        c = [red, green, blue, alpha]
    }

    @inlinable public init(redByte: UInt8, greenByte: UInt8, blueByte: UInt8, alphaByte: UInt8 = 255) {
        let red = Double(redByte) / 255.0
        let green = Double(greenByte) / 255.0
        let blue = Double(blueByte) / 255.0
        let alpha = Double(alphaByte) / 255.0
        c = [red, green, blue, alpha]
    }

    @inlinable public init(white: Double, alpha: Double = 1.0) {
        c = [white, white, white, alpha]
    }

    @inlinable public init(data: Data) {
        let r = data[0]
        let g = data[1]
        let b = data[2]
        let a = data.count >= 4 ? data[3] : 255
        self.init(redByte: r, greenByte: g, blueByte: b, alphaByte: a)
    }

    @inlinable public init(color: Color, alpha: Double) {
        c = [color.red, color.green, color.blue, alpha]
    }

    private static func components(forSingleHexStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            guard let i = Data(hex: string) else {
                throw WolfColorError("Invalid hex digit.")
            }
            components[index] = Double(i[0]) / 15.0
        }
    }

    private static func components(forDoubleHexStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            guard let i = Data(hex: string) else {
                throw WolfColorError("Invalid hex digit.")
            }
            components[index] = Double(i[0]) / 255.0
        }
    }

    private static func components(forFloatStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            if let f = Double(string) {
                components[index] = Double(f)
            }
        }
    }

    private static func components(forLabeledStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            if let f = Double(string) {
                components[index] = Double(f)
            }
        }
    }

    private static func components(forLabeledHSBStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            if let f = Double(string) {
                components[index] = Double(f)
            }
        }
    }

    public init(string s: String) throws {
        var components: [Double] = [0.0, 0.0, 0.0, 1.0]
        var isHSB = false

        if let strings = singleHexColorRegex.matchedSubstrings(inString: s) {
            try type(of: self).components(forSingleHexStrings: strings, components: &components)
        } else if let strings = doubleHexColorRegex.matchedSubstrings(inString: s) {
            try type(of: self).components(forDoubleHexStrings: strings, components: &components)
        } else if let strings = floatColorRegex.matchedSubstrings(inString: s) {
            try type(of: self).components(forFloatStrings: strings, components: &components)
        } else if let strings = labeledColorRegex.matchedSubstrings(inString: s) {
            try type(of: self).components(forLabeledStrings: strings, components: &components)
        } else if let strings = labeledHSBColorRegex.matchedSubstrings(inString: s) {
            isHSB = true
            try type(of: self).components(forLabeledHSBStrings: strings, components: &components)
        } else {
            throw WolfColorError("Invalid color string format")
        }

        if isHSB {
            self = Color(HSBColor(hue: components[0], saturation: components[1], brightness: components[2], alpha: components[3]))
        } else {
            self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        }
    }

    public static func random(alpha: Double = 1.0) -> Color {
        return Color(
            red: Double.randomFrac(),
            green: Double.randomFrac(),
            blue: Double.randomFrac(),
            alpha: alpha
        )
    }

    public static func random<T>(alpha: Double = 1.0, using generator: inout T) -> Color where T: RandomNumberGenerator {
        return Color(
            red: Double.randomFrac(using: &generator),
            green: Double.randomFrac(using: &generator),
            blue: Double.randomFrac(using: &generator),
            alpha: alpha
        )
    }

    // NOTE: Not gamma-corrected
    public var luminance: Double {
        return red * 0.2126 + green * 0.7152 + blue * 0.0722
    }

    public func withAlphaComponent(_ alpha: Double) -> Color {
        return Color(color: self, alpha: alpha)
    }

    public func multiplied(by rhs: Double) -> Color {
        return Color(red: red * rhs, green: green * rhs, blue: blue * rhs, alpha: alpha)
    }

    public func added(to rhs: Color) -> Color {
        return Color(red: red + rhs.red, green: green + rhs.green, blue: blue + rhs.blue, alpha: alpha)
    }

    public func lightened(by frac: Double) -> Color {
        return Color(
            red: frac.interpolate(to: (red, 1)),
            green: frac.interpolate(to: (green, 1)),
            blue: frac.interpolate(to: (blue, 1)),
            alpha: alpha)
    }

    public static func lightened(by frac: Double) -> (Color) -> Color {
        return { $0.lightened(by: frac) }
    }

    public func darkened(by frac: Double) -> Color {
        return Color(
            red: frac.interpolate(to: (red, 0)),
            green: frac.interpolate(to: (green, 0)),
            blue: frac.interpolate(to: (blue, 0)),
            alpha: alpha)
    }

    public static func darkened(by frac: Double) -> (Color) -> Color {
        return { $0.darkened(by: frac) }
    }

    /// Identity fraction is 0.0
    public func dodged(by frac: Double) -> Color {
        let f = max(1.0 - frac, 1.0e-7)
        return Color(
            red: min(red / f, 1.0),
            green: min(green / f, 1.0),
            blue: min(blue / f, 1.0),
            alpha: alpha)
    }

    public static func dodged(by frac: Double) -> (Color) -> Color {
        return { $0.dodged(by: frac) }
    }

    /// Identity fraction is 0.0
    public func burned(by frac: Double) -> Color {
        let f = max(1.0 - frac, 1.0e-7)
        return Color(
            red: min(1.0 - (1.0 - red) / f, 1.0),
            green: min(1.0 - (1.0 - green) / f, 1.0),
            blue: min(1.0 - (1.0 - blue) / f, 1.0),
            alpha: alpha)
    }

    public static func burned(by frac: Double) -> (Color) -> Color {
        return { $0.burned(by: frac) }
    }

    public static let black = Color(red: 0, green: 0, blue: 0, alpha: 1)
    public static let darkGray = Color(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
    public static let lightGray = Color(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
    public static let white = Color(red: 1, green: 1, blue: 1, alpha: 1)
    public static let gray = Color(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
    public static let red = Color(red: 1, green: 0, blue: 0, alpha: 1)
    public static let green = Color(red: 0, green: 1, blue: 0, alpha: 1)
    public static let darkGreen = Color(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    public static let blue = Color(red: 0, green: 0, blue: 1, alpha: 1)
    public static let cyan = Color(red: 0, green: 1, blue: 1, alpha: 1)
    public static let yellow = Color(red: 1, green: 1, blue: 0, alpha: 1)
    public static let magenta = Color(red: 1, green: 0, blue: 1, alpha: 1)
    public static let orange = Color(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    public static let purple = Color(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    public static let brown = Color(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
    public static let clear = Color(red: 0, green: 0, blue: 0, alpha: 0)
    public static let pink = Color(red: 1, green: 0.75294118, blue: 0.79607843)

    public static let chartreuse = WolfColor.blend(from: .yellow, to: .green, at: 0.5)
    public static let gold = Color(redByte: 251, greenByte: 212, blueByte: 55)
    public static let blueGreen = Color(redByte: 0, greenByte: 169, blueByte: 149)
    public static let mediumBlue = Color(redByte: 0, greenByte: 110, blueByte: 185)
    public static let deepBlue = Color(redByte: 60, greenByte: 55, blueByte: 149)
}

extension Color: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Double

    public init(arrayLiteral elements: Double...) {
        c = SIMD4<Double>(elements[0], elements[1], elements[2], elements[3])
    }
}

extension Color: Equatable { }

public func == (left: Color, right: Color) -> Bool {
    return left.red == right.red &&
        left.green == right.green &&
        left.blue == right.blue &&
        left.alpha == right.alpha
}

extension Color: CustomStringConvertible {
    public var description: String {
        return "Color\(debugSummary)"
    }
}

extension Color {
    public var debugSummary: String {
        let joiner = Joiner(left: "(", right: ")")
        var needAlpha = true
        switch (red, green, blue, alpha) {
        case (0, 0, 0, 0):
            joiner.append("clear")
            needAlpha = false
        case (0, 0, 0, _):
            joiner.append("black")
        case (1, 1, 1, _):
            joiner.append("white")
        case (0.5, 0.5, 0.5, _):
            joiner.append("gray")
        case (1, 0, 0, _):
            joiner.append("red")
        case (0, 1, 0, _):
            joiner.append("green")
        case (0, 0, 1, _):
            joiner.append("blue")
        case (0, 1, 1, _):
            joiner.append("cyan")
        case (1, 0, 1, _):
            joiner.append("magenta")
        case (1, 1, 0, _):
            joiner.append("yellow")
        default:
            joiner.append("r:\(String(value: red, precision: 2)) g:\(String(value: green, precision: 2)) b:\(String(value: blue, precision: 2))")
        }
        if needAlpha && alpha < 1.0 {
            joiner.append("a: \(String(value: alpha, precision: 2))")
        }
        return joiner.description
    }
}

@inlinable public func * (lhs: Color, rhs: Double) -> Color {
    return lhs.multiplied(by: rhs)
}

@inlinable public func + (lhs: Color, rhs: Color) -> Color {
    return lhs.added(to: rhs)
}

extension Color {
    public func blend(to color: Color, at t: Double) -> Color {
        return WolfColor.blend(from: self, to: color, at: t)
    }
}

extension Color: ForwardInterpolable {
    public func interpolate(to other: Color, at t: Double) -> Color {
        return blend(to: other, at: t)
    }
}
