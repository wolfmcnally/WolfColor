//
//  CGColorUtils.swift
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

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

import CoreGraphics

public var sharedColorSpaceRGB = CGColorSpaceCreateDeviceRGB()
public var sharedColorSpaceGray = CGColorSpaceCreateDeviceGray()
public var sharedWhiteColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(1.0), CGFloat(1.0)])
public var sharedBlackColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(0.0), CGFloat(1.0)])
public var sharedClearColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(0.0), CGFloat(0.0)])

extension CGColor {
    public func toRGB() -> CGColor {
        switch colorSpace!.model {
        case CGColorSpaceModel.monochrome:
            let c = components!
            let gray = c[0]
            let a = c[1]
            return CGColor(colorSpace: sharedColorSpaceRGB, components: [gray, gray, gray, a])!
        case CGColorSpaceModel.rgb:
            return self
        default:
            fatalError("unsupported color model")
        }
    }
}

extension CGGradient {
    public static func new(with gradient: ColorFracGradient) -> CGGradient {
        var cgColors = [CGColor]()
        var locations = [CGFloat]()
        for colorFrac in gradient.colorFracs {
            cgColors.append(colorFrac.color.cgColor)
            locations.append(CGFloat(colorFrac.frac))
        }
        return CGGradient(colorsSpace: sharedColorSpaceRGB, colors: cgColors as CFArray, locations: locations)!
    }

    public static func new(from color1: Color, to color2: Color) -> CGGradient {
        return new(with: ColorFracGradient([ColorFrac(color1, 0.0), ColorFrac(color2, 1.0)]))
    }

    #if canImport(UIKit)
    public static func new(from color1: UIColor, to color2: UIColor) -> CGGradient {
        return new(from: Color(color1), to: Color(color2))
    }
    #elseif canImport(AppKit)
    public static func new(from color1: NSColor, to color2: NSColor) -> CGGradient {
        return new(from: Color(color1), to: Color(color2))
    }
    #endif
}

extension Color {
    public var cgColor: CGColor {
        return CGColor(colorSpace: sharedColorSpaceRGB, components: [CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(alpha)])!
    }
}

public func toCGColor(_ c: Color) -> CGColor {
    return c.cgColor
}

public func toColor(_ c: CGColor) -> Color {
    return Color(cgColor: c)
}
