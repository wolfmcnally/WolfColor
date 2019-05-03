//
//  LABColor.swift
//  WolfColor
//
//  Created by Wolf McNally on 1/9/19.
//

import WolfCore

public struct LABColor: Codable {
    public var c: SIMD4<Double>

    public static let minL = 0.0        // Darkest black
    public static let maxL = 100.0      // Brightest white
    @inlinable public var l: Double {
        get { return c[0] }
        set { c[0] = newValue }
    }

    public static let minA = -100.0     // Green
    public static let maxA = 100.0      // Red
    @inlinable public var a: Double {
        get { return c[1] }
        set { c[1] = newValue }
    }

    public static let minB = -100.0     // Blue
    public static let maxB = 100.0      // Yellow
    @inlinable public var b: Double {
        get { return c[2] }
        set { c[2] = newValue }
    }

    @inlinable public var alpha: Frac {
        get { return c[3] }
        set { c[3] = newValue }
    }

    @inlinable public init(l: Double, a: Double, b: Double, alpha: Frac = 1) {
        c = [l, a, b, alpha]
    }

    public init(_ color: Color) {
        let red = (color.red > 0.04045) ? pow((color.red + 0.055) / 1.055, 2.4) : color.red / 12.92
        let green = (color.green > 0.04045) ? pow((color.green + 0.055) / 1.055, 2.4) : color.green / 12.92
        let blue = (color.blue > 0.04045) ? pow((color.blue + 0.055) / 1.055, 2.4) : color.blue / 12.92

        let x = (red * 0.4124 + green * 0.3576 + blue * 0.1805) / 0.95047
        let y = (red * 0.2126 + green * 0.7152 + blue * 0.0722) / 1.00000
        let z = (red * 0.0193 + green * 0.1192 + blue * 0.9505) / 1.08883

        let x2 = (x > 0.008856) ? pow(x, 1/3) : (7.787 * x) + 16/116
        let y2 = (y > 0.008856) ? pow(y, 1/3) : (7.787 * y) + 16/116
        let z2 = (z > 0.008856) ? pow(z, 1/3) : (7.787 * z) + 16/116

        let l = (116 * y2) - 16
        let a = 500 * (x2 - y2)
        let b = 200 * (y2 - z2)
        c = [l, a, b, color.alpha]
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

        let red = max(0, min(1, r2))
        let green = max(0, min(1, g2))
        let blue = max(0, min(1, b2))
        let alpha = lab.alpha
        self = [red, green, blue, alpha]
    }
}

@inlinable public func toLABColor(_ c: Color) -> LABColor {
    return LABColor(c)
}

@inlinable public func toColor(_ c: LABColor) -> Color {
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
        return "LABColor(l: \(l), a: \(a), b: \(b), alpha: \(alpha))"
    }
}
