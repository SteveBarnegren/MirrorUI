//
//  LayoutConstraint.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 02/04/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

enum LayoutConstraintValue {
    case fixed(Double)
    case greaterThan(Double)
}

struct Weak<T: AnyObject> {
    weak var value: T?
    
    init(value: T) {
        self.value = value
    }
}

enum LayoutConstraintFromTarget {
    case anchor(Weak<LayoutAnchor>)
    case previousAnchor
    
    var isEnabled: Bool {
        switch self {
        case .anchor(let a):
            return a.value?.enabled ?? false
        case .previousAnchor:
            return true
        }
    }
    
    var layoutAnchor: LayoutAnchor? {
        switch self {
        case .anchor(let anchor):
            return anchor.value
        case .previousAnchor:
            return nil
        }
    }
}

enum LayoutConstraintToTarget {
    case anchor(Weak<LayoutAnchor>)
    case nextAnchor
    
    var isEnabled: Bool {
        switch self {
        case .anchor(let a):
            return a.value?.enabled ?? false
        case .nextAnchor:
            return true
        }
    }
    
    var layoutAnchor: LayoutAnchor? {
        switch self {
        case .anchor(let anchor):
            return anchor.value
        case .nextAnchor:
            return nil
        }
    }
}

class LayoutConstraint {
    var from: LayoutConstraintFromTarget
    var to: LayoutConstraintToTarget
    var value = LayoutConstraintValue.greaterThan(0)
    
    var isEnabled: Bool {
        return from.isEnabled && to.isEnabled
    }
    
    init(fromPreviousTo to: LayoutAnchor, value: LayoutConstraintValue) {
        self.from = .previousAnchor
        self.to = .anchor(Weak(value: to))
        self.value = value
    }
    
    init(from: LayoutAnchor, to: LayoutAnchor, value: LayoutConstraintValue) {
        self.from = .anchor(Weak(value: from))
        self.to = .anchor(Weak(value: to))
        self.value = value
    }
    
    func activate() {
        
        let fromAnchor = from.layoutAnchor
        let toAnchor = to.layoutAnchor
        
        assert(fromAnchor != nil || toAnchor != nil, "There is no layout anchor to attach this constraint to")
        
        fromAnchor?.add(trailingConstraint: self)
        toAnchor?.add(leadingConstraint: self)
    }
}
