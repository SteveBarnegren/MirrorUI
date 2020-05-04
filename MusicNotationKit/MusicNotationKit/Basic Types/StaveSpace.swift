//
//  StaveSpace.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 04/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

struct StaveSpace: Equatable {
    
    enum Sign: Equatable {
        case positive
        case negative
    }
    
    let space: UInt
    let sign: Sign
    
    var isPositive: Bool {
        return sign == .positive
    }
    
    var isNegative: Bool {
        return sign == .negative
    }
    
    init(_ space: UInt, _ sign: Sign) {
        self.space = space
        self.sign = sign
    }
    
    func adding(spaces spacesToAdd: Int) -> StaveSpace {
        
        let existingValue: Int = isPositive ? Int(space) : -Int(space)
        var newValue = existingValue + spacesToAdd
        let newSign: Sign
        
        if newValue != 0 && isPositive != newValue.isPositive {
            newSign = newValue.isPositive ? .positive : .negative
            let offset = newValue.isPositive ? -1 : 1
            newValue += offset
        } else {
            newSign = sign
        }
        
        return StaveSpace(UInt(abs(newValue)), newSign)
    }
    
    func subtracting(spaces spacesToSubtract: Int) -> StaveSpace {
        return self.adding(spaces: -spacesToSubtract)
    }
}

// MARK: - Stave Position

extension StaveSpace {
    
    enum LineRounding {
        case spaceAbove
        case spaceBelow
    }
    
    init(stavePosition: Int, lineRounding: LineRounding) {
        
        switch lineRounding {
        case .spaceAbove:
            if stavePosition == 0 {
                self.space = 0
            } else {
                var space = UInt(abs: stavePosition.nearestEven(rounding: .down) / 2)
                if stavePosition.isNegative { space -= 1 }
                self.space = space
            }
            
            self.sign = stavePosition.isPositive ? .positive : .negative
            
        case .spaceBelow:
            if stavePosition == 0 {
                self.space = 0
                self.sign = .negative
            } else {
                var space = UInt(abs: (stavePosition.nearestOdd(rounding: .down)-1) / 2)
                if stavePosition.isNegative { space -= 1 }
                self.space = space
                self.sign = stavePosition.isPositive ? .positive : .negative
            }
        }
    }
    
    var stavePosition: Int {
        let position = Int(space)*2 + 1
        return self.isPositive ? position : -position
    }
}
