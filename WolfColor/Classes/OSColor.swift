//
//  OSColor.swift
//  WolfColor
//
//  Created by Wolf McNally on 6/25/17.
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

import WolfNumerics

#if canImport(AppKit)
import AppKit
public typealias OSColor = NSColor
#elseif canImport(UIKit)
import UIKit
public typealias OSColor = UIColor
#endif

#if !os(macOS)
import ExtensibleEnumeratedName

@available(iOS 11.0, *)
extension UIColor {
    public struct Name: ExtensibleEnumeratedName {
        public let rawValue: String

        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }

        // RawRepresentable
        public init?(rawValue: String) { self.init(rawValue) }
    }

    public convenience init?(named name: UIColor.Name) {
        self.init(named: name.rawValue)
    }
}
#endif

extension OSColor: Interpolable {
    public func interpolated(to other: OSColor, at frac: Frac) -> Self {
        var thisR: CGFloat = 0
        var thisG: CGFloat = 0
        var thisB: CGFloat = 0
        var thisA: CGFloat = 0
        getRed(&thisR, green: &thisG, blue: &thisB, alpha: &thisA)

        var endR: CGFloat = 0
        var endG: CGFloat = 0
        var endB: CGFloat = 0
        var endA: CGFloat = 0
        other.getRed(&endR, green: &endG, blue: &endB, alpha: &endA)

        let r = thisR.interpolated(to: endR, at: frac)
        let g = thisG.interpolated(to: endG, at: frac)
        let b = thisB.interpolated(to: endB, at: frac)
        let a = thisA.interpolated(to: endA, at: frac)
        return type(of: self).init(red: r, green: g, blue: b, alpha: a)
    }
}
