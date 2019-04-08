//
//  LABColor.swift
//  WolfColor
//
//  Created by Wolf McNally on 1/9/19.
//

import WolfCore

public struct LABColor: Codable {
    public var l: Double
    public var a: Double
    public var b: Double
    public var alpha: Frac

    public init(l: Double, a: Double, b: Double, alpha: Frac = 1) {
        self.l = l
        self.a = a
        self.b = b
        self.alpha = alpha
    }

    public init(_ color: Color) {
        let r = (color.red > 0.04045) ? pow((color.red + 0.055) / 1.055, 2.4) : color.red / 12.92
        let g = (color.green > 0.04045) ? pow((color.green + 0.055) / 1.055, 2.4) : color.green / 12.92
        let b = (color.blue > 0.04045) ? pow((color.blue + 0.055) / 1.055, 2.4) : color.blue / 12.92

        let x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047
        let y = (r * 0.2126 + g * 0.7152 + b * 0.0722) / 1.00000
        let z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883

        let x2 = (x > 0.008856) ? pow(x, 1/3) : (7.787 * x) + 16/116
        let y2 = (y > 0.008856) ? pow(y, 1/3) : (7.787 * y) + 16/116
        let z2 = (z > 0.008856) ? pow(z, 1/3) : (7.787 * z) + 16/116

        self = LABColor(l: (116 * y2) - 16, a: 500 * (x2 - y2), b: 200 * (y2 - z2), alpha: color.alpha)
    }
}

extension Color {
    public init(_ lab: LABColor) {
        let y = (lab.l + 16) / 116
        let x = lab.a / 500 + y
        let z = y - lab.b / 200

        let x2 = 0.95047 * ((x * x * x > 0.008856) ? x * x * x : (x - 16/116) / 7.787)
        let y2 = 1.00000 * ((y * y * y > 0.008856) ? y * y * y : (y - 16/116) / 7.787)
        let z2 = 1.08883 * ((z * z * z > 0.008856) ? z * z * z : (z - 16/116) / 7.787)

        let r = x2 *  3.2406 + y2 * -1.5372 + z2 * -0.4986
        let g = x2 * -0.9689 + y2 *  1.8758 + z2 *  0.0415
        let b = x2 *  0.0557 + y2 * -0.2040 + z2 *  1.0570

        let r2 = (r > 0.0031308) ? (1.055 * pow(r, 1/2.4) - 0.055) : 12.92 * r
        let g2 = (g > 0.0031308) ? (1.055 * pow(g, 1/2.4) - 0.055) : 12.92 * g
        let b2 = (b > 0.0031308) ? (1.055 * pow(b, 1/2.4) - 0.055) : 12.92 * b

        red = max(0, min(1, r2))
        green = max(0, min(1, g2))
        blue = max(0, min(1, b2))
        alpha = lab.alpha
    }
}

public func toLABColor(_ c: Color) -> LABColor {
    return LABColor(c)
}

public func toColor(_ c: LABColor) -> Color {
    return Color(c)
}

public func settingL(to l: Double) -> (_ c: LABColor) -> LABColor {
    return { c in
        var c2 = c
        c2.l = l
        return c2
    }
}

public func settingL(toMatch source: Color) -> (_ target: Color) -> Color {
    return { target in
        return target |> toLABColor |> settingL(to: (source |> toLABColor).l) |> toColor
    }
}

extension LABColor: CustomStringConvertible {
    public var description: String {
        return "LABColor(l: \(l), a: \(a), b: \(b)"
    }
}
