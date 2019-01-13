//
//  HorizontallyConstrained.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

enum ConstraintPriority: Comparable {
   
    case required
    case regular
    
    static var allCasesIncreasing: [ConstraintPriority] {
        return [.regular, .required]
    }
    
    private var orderingValue: Int {
        switch self {
        case .required: return 1
        case .regular: return 0
        }
    }
    
    static func < (lhs: ConstraintPriority, rhs: ConstraintPriority) -> Bool {
        return lhs.orderingValue < rhs.orderingValue
    }
}

struct ConstraintValue {
    var length: Double
    var priority: ConstraintPriority
}

struct HorizontalConstraint {
    var values: [ConstraintValue]
    
    func minimumDistance(atPriority priority: ConstraintPriority) -> Double {
        let distance = self.values
            .sortedAscendingBy { $0.priority }
            .first { $0.priority >= priority }?.length
        
        return distance ?? 0
    }
}

protocol HorizontallyConstrained: class, HorizontallyPositionable {
    var layoutDuration: Time? { get }
    //var leadingWidth: Double { get set }
    //var trailingWidth: Double { get set }
    var leadingConstraints: [HorizontalConstraint] { get }
    var trailingConstraints: [HorizontalConstraint] { get }
}
