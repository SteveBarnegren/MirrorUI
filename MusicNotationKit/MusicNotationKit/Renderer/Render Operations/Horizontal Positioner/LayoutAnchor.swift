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

// MARK: - ******* Layout Anchor ********

protocol LayoutAnchor: class {
    var width: Double { get }
    var time: Time { get set }
    var leadingConstraints: [LayoutConstraint] { get }
    var trailingConstraints: [LayoutConstraint] { get }
    var resolvedPosition: Double { get set }
    var minimumTrailingDistance: Double { get set }
    var resolvedTrailingDistance: Double { get set }
    var isSolved: Bool { get set }
    var trailingTimeValue: Double? { get }

    
    func apply()
}

class SingleItemLayoutAnchor: LayoutAnchor {
    
    // LayoutAnchor
    var width = Double(0)
    var leadingConstraints = [LayoutConstraint]()
    var trailingConstraints = [LayoutConstraint]()
    var resolvedPosition: Double = 0
    var minimumTrailingDistance = Double(0)
    var resolvedTrailingDistance = Double(0)
    var isSolved = false
    var time: Time = .zero
    
    var trailingTimeValue: Double? {
        return self.trailingConstraints.compactMap { $0.timeValue }.max()
    }
    
    var item: HorizontallyPositionable
    
    init(item: HorizontallyPositionable) {
        self.item = item
    }
    
    func add(leadingConstraint: LayoutConstraint) {
        self.leadingConstraints.append(leadingConstraint)
    }
    
    func add(trailingConstraint: LayoutConstraint) {
        self.trailingConstraints.append(trailingConstraint)
    }
    
    func apply() {
        self.item.xPosition = self.resolvedPosition
    }
}

class CombinedItemsLayoutAnchor: LayoutAnchor {
    
    // LayoutAnchor
    var width: Double {
        return anchors.map { $0.width }.max() ?? 0
    }
    var leadingConstraints: [LayoutConstraint]
    var trailingConstraints: [LayoutConstraint]
    var resolvedPosition: Double = 0
    var minimumTrailingDistance = Double(0)
    var resolvedTrailingDistance = Double(0)
    var isSolved = false
    var time: Time = .zero
    
    var trailingTimeValue: Double? {
        return self.trailingConstraints.compactMap { $0.timeValue }.min()
    }
    
    private let anchors: [LayoutAnchor]
    
    init(anchors: [LayoutAnchor]) {
        self.anchors = anchors
        self.leadingConstraints = anchors.map { $0.leadingConstraints }.joined().toArray()
        self.trailingConstraints = anchors.map { $0.trailingConstraints }.joined().toArray()
    }
    
    func apply() {
        for anchor in anchors {
            anchor.resolvedPosition = resolvedPosition
            anchor.apply()
        }
    }
}
