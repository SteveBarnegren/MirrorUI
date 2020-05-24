//
//  FloatingPoint+Extensions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 13/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

extension FloatingPoint {
    
    func pct(between from: Self, and to: Self) -> Self {
        
        let diff = to - from
        let value = self - from
        return value / diff
    }
    
    func interpolate(to other: Self, t: Self) -> Self {
        let diff = other - self
        return self + (diff * t)
    }
    
    func lerp(to other: Self, t: Self) -> Self {
        let diff = other - self
        return self + (diff * t)
    }
    
    func inverseLerp(between start: Self, and end: Self) -> Self {
        let totalDistance = end - start
        let offset = self - start
        return offset / totalDistance
    }
}
