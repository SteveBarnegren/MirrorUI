//
//  LayoutAnchor.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 20/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
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
}

// MARK: - ******* Layout Anchor ********

protocol LayoutAnchor: class {
    var width: Double { get }
    var leadingConstraints: [LayoutConstraint] { get set }
    var trailingConstraints: [LayoutConstraint] { get set }
    var position: Double { get set }
    var trailingEdge: Double { get }
    var duration: Time { get }
    var time: Time { get }
    
    func apply()
}

extension LayoutAnchor {
    func add(leadingConstraint: LayoutConstraint) {
        self.leadingConstraints.append(leadingConstraint)
    }
    
    func add(trailingConstraint: LayoutConstraint) {
        self.trailingConstraints.append(trailingConstraint)
    }
}

class SingleItemLayoutAnchor: LayoutAnchor {
    
    // LayoutAnchor
    var width = Double(0)
    var leadingConstraints = [LayoutConstraint]()
    var trailingConstraints = [LayoutConstraint]()
    var position: Double = 0
    var isSolved = false
    var time: Time = .zero
    var duration: Time = .zero
    var leadingLayoutItems = [AdjacentLayoutItem]()
    var trailingLayoutItems = [AdjacentLayoutItem]()
    
    var trailingEdge: Double {
        if let lastTrailingItem = trailingLayoutItems.last {
            return lastTrailingItem.trailingEdge
        } else {
            return position + width/2
        }
    }
    
    var item: HorizontallyPositionable
    
    init(item: HorizontallyPositionable) {
        self.item = item
    }
    
    func add(trailingItem: AdjacentLayoutItem) {
        self.trailingLayoutItems.append(trailingItem)
    }
    
    func add(leadingItem: AdjacentLayoutItem) {
        self.leadingLayoutItems.append(leadingItem)
    }
    
    func apply() {
        self.item.xPosition = self.position
        trailingLayoutItems.forEach { $0.apply() }
    }
}

class AdjacentLayoutItem {
    
    var width = Double(0)
    var distanceFromAnchor = Double(0)
    var position: Double = 0
    var item: HorizontallyPositionable
    
    var trailingEdge: Double {
        return position + width/2
    }
    
    init(item: HorizontallyPositionable) {
        self.item = item
    }
    
    func apply() {
        self.item.xPosition = position
    }
}

class CombinedItemsLayoutAnchor: LayoutAnchor {
    
    // LayoutAnchor
    var width: Double { return anchors.map { $0.width }.max()! }
    var trailingConstraints: [LayoutConstraint]
    var leadingConstraints: [LayoutConstraint]
    var position: Double = 0 {
        didSet {
            anchors.forEach { $0.position = position }
        }
    }
    var time: Time = .zero
    var duration: Time = .zero
    var trailingEdge: Double {
        let lastAnchors = anchors.compactMap { $0.trailingLayoutItems.last }
        if lastAnchors.isEmpty == false {
            return lastAnchors.map { $0.trailingEdge }.max()!
        } else {
            return position + width/2
        }
    }
    
    let anchors: [SingleItemLayoutAnchor]
    
    init(anchors: [SingleItemLayoutAnchor]) {
        self.anchors = anchors
        self.leadingConstraints = anchors.map { $0.leadingConstraints }.joined().toArray()
        self.trailingConstraints = anchors.map { $0.trailingConstraints }.joined().toArray()
    }
    
    func apply() {
        for anchor in anchors {
            anchor.position = position
            anchor.apply()
        }
    }
}
