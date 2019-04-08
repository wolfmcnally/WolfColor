//
//  HSBColor.swift
//  WolfColor
//
//  Created by Wolf McNally on 1/10/19.
//

import WolfCore

public struct HSBColor: Codable {
    public var hue: Frac
    public var saturation: Frac
    public var brightness: Frac
    public var alpha: Frac

    public init(hue: Frac, saturation: Frac, brightness: Frac, alpha: Frac = 1) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }

    public init(_ color: Color) {
        let r = color.red
        let g = color.green
        let b = color.blue
        alpha = color.alpha

        let maxValue = max(r, g, b)
        let minValue = min(r, g, b)

        brightness = maxValue

        let d = maxValue - minValue;
        saturation = maxValue == 0 ? 0 : d / maxValue

        if (maxValue == minValue) {
            hue = 0 // achromatic
        } else {
            switch maxValue {
            case r: hue = ((g - b) / d + (g < b ? 6 : 0)) / 6
            case g: hue = ((b - r) / d + 2) / 6
            case b: hue = ((r - g) / d + 4) / 6
            default: fatalError()
            }
        }
    }
}

extension Color {
    public init(_ hsb: HSBColor) {
        let v = hsb.brightness.clamped()
        let s = hsb.saturation.clamped()
        alpha = hsb.alpha
        if s <= 0.0 {
            red = v
            green = v
            blue = v
        } else {
            var h = hsb.hue.truncatingRemainder(dividingBy: 1.0)
            if h < 0.0 { h += 1.0 }
            h *= 6.0
            let i = Int(floor(h))
            let f = h - Double(i)
            let p = v * (1.0 - s)
            let q = v * (1.0 - (s * f))
            let t = v * (1.0 - (s * (1.0 - f)))
            switch i {
            case 0: red = v; green = t; blue = p
            case 1: red = q; green = v; blue = p
            case 2: red = p; green = v; blue = t
            case 3: red = p; green = q; blue = v
            case 4: red = t; green = p; blue = v
            case 5: red = v; green = p; blue = q
            default: red = 0; green = 0; blue = 0; assert(false, "unknown hue sector")
            }
        }
    }
}

public func toHSBColor(_ c: Color) -> HSBColor {
    return HSBColor(c)
}

public func toColor(_ c: HSBColor) -> Color {
    return Color(c)
}
