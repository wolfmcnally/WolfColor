//
//  Random.swift
//  WolfColor
//
//  Created by Wolf McNally on 12/20/20.
//

import Foundation

extension BinaryFloatingPoint where RawSignificand: FixedWidthInteger {
    static func randomFrac() -> Self {
        Self.random(in: 0..<1)
    }

    static func randomFrac<G: RandomNumberGenerator>(using generator: inout G) -> Self {
        Self.random(in: 0..<1, using: &generator)
    }
}
