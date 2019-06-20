//
//  LayoutAnchor.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 20/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

enum LayoutConstraintValue {
    case time(Double)
    case greaterThan(Double)
    //case flexible
}

class LayoutConstraint {
    weak var from: LayoutAnchor?
    weak var to: LayoutAnchor?
    var value = LayoutConstraintValue.greaterThan(0)
    var resolvedValue = Double(0)
    
    var minimumValue: Double? {
        switch self.value {
        case .greaterThan(let v):
            return v
        case .time:
            return nil
        }
    }
    
    var timeValue: Double? {
        switch self.value {
        case .time(let t):
            return t
        default:
            return nil
        }
    }
}

class LayoutAnchor {
    
    var width = Double(0)
    var leadingConstraints = [LayoutConstraint]()
    var trailingConstraints = [LayoutConstraint]()
    var resolvedPosition: Double = 0
    var item: HorizontallyPositionable
    var minimumTrailingDistance = Double(0)
    var resolvedTrailingDistance = Double(0)
    var isSolved = false
    
    init(item: HorizontallyPositionable) {
        self.item = item
    }
    
    func add(leadingConstraint: LayoutConstraint) {
        self.leadingConstraints.append(leadingConstraint)
    }
    
    func add(trailingConstraint: LayoutConstraint) {
        self.trailingConstraints.append(trailingConstraint)
    }
    
    var trailingTimeValue: Double? {
        return self.trailingConstraints.compactMap { $0.timeValue }.max()
    }
}
