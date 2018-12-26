//
//  StringUtils.swift
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

import CoreGraphics

extension String {
    init(value: Double, precision: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        self.init(formatter.string(from: NSNumber(value: value))!)
    }

    init(value: Float, precision: Int) {
        self.init(value: Double(value), precision: precision)
    }

    init(value: CGFloat, precision: Int) {
        self.init(value: Double(value), precision: precision)
    }

    func nsRange(from stringRange: StringRange?) -> NSRange? {
        guard let stringRange = stringRange else { return nil }
        let utf16view = utf16
        let from = String.UTF16View.Index(stringRange.lowerBound, within: utf16view)!
        let to = String.UTF16View.Index(stringRange.upperBound, within: utf16view)!
        let location = utf16view.distance(from: utf16view.startIndex, to: from)
        let length = utf16view.distance(from: from, to: to)
        return NSRange(location: location, length: length)
    }

    var nsRange: NSRange {
        return nsRange(from: stringRange)!
    }

    var stringRange: StringRange {
        return startIndex..<endIndex
    }

    func stringRange(nsLocation: Int, nsLength: Int) -> StringRange? {
        let utf16view = utf16
        let from16 = utf16view.index(utf16view.startIndex, offsetBy: nsLocation, limitedBy: utf16view.endIndex)!
        let to16 = utf16view.index(from16, offsetBy: nsLength, limitedBy: utf16view.endIndex)!
        if let from = StringIndex(from16, within: self),
            let to = StringIndex(to16, within: self) {
            return from ..< to
        }
        return nil
    }

    func stringRange(from nsRange: NSRange?) -> StringRange? {
        guard let nsRange = nsRange else { return nil }
        return stringRange(nsLocation: nsRange.location, nsLength: nsRange.length)
    }
}

precedencegroup AttributeAssignmentPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: ComparisonPrecedence
}

infix operator %% : AttributeAssignmentPrecedence

func %% (left: Double, right: Int) -> String {
    return String(value: left, precision: right)
}

func %% (left: Float, right: Int) -> String {
    return String(value: left, precision: right)
}

func %% (left: CGFloat, right: Int) -> String {
    return String(value: left, precision: right)
}

typealias TextCheckingResult = NSTextCheckingResult
typealias StringIndex = String.Index
typealias StringRange = Range<StringIndex>

extension NSRegularExpression {
    func firstMatch(inString string: String, options: NSRegularExpression.MatchingOptions, range: StringRange? = nil) -> TextCheckingResult? {
        let range = range ?? string.stringRange
        let nsRange = string.nsRange(from: range)!
        return firstMatch(in: string, options: options, range: nsRange)
    }

    func matchedSubstrings(inString string: String, options: NSRegularExpression.MatchingOptions = [], range: StringRange? = nil) -> [String]? {
        var result: [String]! = nil
        if let textCheckingResult = self.firstMatch(inString: string, options: options, range: range) {
            result = [String]()
            for range in textCheckingResult.captureRanges(in: string) {
                let matchText = String(string[range])
                result.append(matchText)
            }
        }
        return result
    }
}

class Joiner {
    var left: String
    var right: String
    var separator: String
    var objs = [Any]()
    var count: Int { return objs.count }
    var isEmpty: Bool { return objs.isEmpty }

    init(left: String = "", separator: String = " ", right: String = "") {
        self.left = left
        self.right = right
        self.separator = separator
    }

    func append(_ objs: Any...) {
        self.objs.append(contentsOf: objs)
    }

    func append<S: Sequence>(contentsOf newElements: S) {
        for element in newElements {
            objs.append(element)
        }
    }
}

extension Joiner: CustomStringConvertible {
    var description: String {
        var s = [String]()
        for o in objs {
            s.append("\(o)")
        }
        let t = s.joined(separator: separator)
        return "\(left)\(t)\(right)"
    }
}

extension TextCheckingResult {
    func stringRange(at index: Int, in string: String) -> StringRange {
        return string.stringRange(from: range(at: index))!
    }

    func captureRanges(in string: String) -> [StringRange] {
        var result = [StringRange]()
        for i in 1 ..< numberOfRanges {
            result.append(stringRange(at: i, in: string))
        }
        return result
    }
}
