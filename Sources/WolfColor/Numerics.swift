//
//  Numerics.swift
//  WolfColor
//
//  Created by Wolf McNally on 12/20/20.
//

import Foundation

extension BinaryFloatingPoint {
    @inlinable var clamped: Self {
        min(max(0, self), 1)
    }
}
