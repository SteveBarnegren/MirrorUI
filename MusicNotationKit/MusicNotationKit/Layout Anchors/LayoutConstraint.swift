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

class LayoutConstraint {
    weak var from: LayoutAnchor?
    weak var to: LayoutAnchor?
    var value = LayoutConstraintValue.greaterThan(0)
    
    var isEnabled: Bool {
        if from?.enabled == false { return false }
        if to?.enabled == false { return false }
        return true
    }
    
    func insert(from: LayoutAnchor, to: LayoutAnchor) {
        self.from = from
        self.to = to
        from.add(trailingConstraint: self)
        to.add(leadingConstraint: self)
    }
}
