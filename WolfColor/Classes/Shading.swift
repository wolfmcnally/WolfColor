//
//  Shading.swift
//  WolfColor
//
//  Created by Wolf McNally on 2/13/17.
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

import CoreGraphics
import WolfNumerics

public class Shading {
    public typealias CallbackBlock = (_ frac: Frac) -> Color
    private typealias `Self` = Shading

    public private(set) var cgShading: CGShading!
    let callback: CallbackBlock
    let numComponents = sharedColorSpaceRGB.numberOfComponents + 1

    public init(start: CGPoint, startRadius: CGFloat, end: CGPoint, endRadius: CGFloat, extendStart: Bool = false, extendEnd: Bool = false, using callback: @escaping CallbackBlock) {
        self.callback = callback
        var callbacks = CGFunctionCallbacks(version: 0, evaluate: { (info, inData, outData) in
            let me = Unmanaged<Self>.fromOpaque(info!).takeUnretainedValue()
            let frac = Frac(inData[0])
            let color = me.callback(frac)
            let components = color.cgColor.components!
            for i in 0 ..< me.numComponents {
                outData[i] = components[i]
            }
        }, releaseInfo: nil)
        let function = CGFunction(info: Unmanaged.passUnretained(self).toOpaque(), domainDimension: 1, domain: [0, 1], rangeDimension: numComponents, range: [0, 1, 0, 1, 0, 1, 0, 1], callbacks: &callbacks)!
        cgShading = CGShading(radialSpace: sharedColorSpaceRGB, start: start, startRadius: startRadius, end: end, endRadius: endRadius, function: function, extendStart: extendStart, extendEnd: extendEnd)!
    }

    public init(start: CGPoint, end: CGPoint, extendStart: Bool = false, extendEnd: Bool = false, using callback: @escaping CallbackBlock) {
        self.callback = callback
        var callbacks = CGFunctionCallbacks(version: 0, evaluate: { (info, inData, outData) in
            let me = Unmanaged<Self>.fromOpaque(info!).takeUnretainedValue()
            let frac = Frac(inData[0])
            let color = me.callback(frac)
            let components = color.cgColor.components!
            for i in 0 ..< me.numComponents {
                outData[i] = components[i]
            }
        }, releaseInfo: nil)
        let function = CGFunction(info: Unmanaged.passUnretained(self).toOpaque(), domainDimension: 1, domain: [0, 1], rangeDimension: numComponents, range: [0, 1, 0, 1, 0, 1, 0, 1], callbacks: &callbacks)!
        cgShading = CGShading(axialSpace: sharedColorSpaceRGB, start: start, end: end, function: function, extendStart: extendStart, extendEnd: extendEnd)
    }
}

extension CGContext {
    public func drawShading(_ shading: Shading) {
        drawShading(shading.cgShading)
    }
}
