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
    
    var isEnabled: Bool {
        if from?.enabled == false { return false }
        if to?.enabled == false { return false }
        else {
            return true
        }
    }
}

enum LayoutAnchorType {
    case unknown
    case leadingClef
}

// MARK: - ******* Layout Anchor ********

protocol LayoutAnchor: class {
    var enabled: Bool { get set }
    var layoutAnchorType: LayoutAnchorType { get set }
    var leadingWidth: Double { get }
    var trailingWidth: Double { get }
    var leadingConstraints: [LayoutConstraint] { get set }
    var trailingConstraints: [LayoutConstraint] { get set }
    var position: Double { get set }
    var leadingEdgeOffset: Double { get }
    var trailingEdge: Double { get }
    var duration: Time? { get set }
    var time: Time { get }
    
    func reset()
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

final class SingleItemLayoutAnchor: LayoutAnchor {
  
    // LayoutAnchor
    var enabled = true
    var layoutAnchorType = LayoutAnchorType.unknown
    var leadingWidth: Double = 0
    var trailingWidth: Double = 0
    var leadingConstraints = [LayoutConstraint]()
    var trailingConstraints = [LayoutConstraint]()
    var position: Double = 0 {
        didSet {
            assert(!position.isNaN)
            assert(!position.isInfinite)
        }
    }
    var isSolved = false
    var time: Time = .zero
    var duration: Time?
    var leadingLayoutAnchors = [AdjacentLayoutAnchor]()
    var trailingLayoutAnchors = [AdjacentLayoutAnchor]()
    
    var leadingEdgeOffset: Double {
        if let leftMostLeadingAnchor = leadingLayoutAnchors.last {
            return leftMostLeadingAnchor.offset - leftMostLeadingAnchor.width/2
        } else {
            return -leadingWidth
        }
    }
    
    var trailingEdge: Double {
        if let lastTrailingAnchor = trailingLayoutAnchors.last {
            return lastTrailingAnchor.trailingEdge(anchorPosition: position)
        } else {
            return position + trailingWidth
        }
    }
    
    var item: HorizontallyPositionable
    
    init(item: HorizontallyPositionable) {
        self.item = item
    }
    
    func add(trailingAnchor: AdjacentLayoutAnchor) {
        self.trailingLayoutAnchors.append(trailingAnchor)
    }
    
    func add(leadingAnchor: AdjacentLayoutAnchor) {
        self.leadingLayoutAnchors.append(leadingAnchor)
    }
    
    func apply() {
        self.item.xPosition = self.position
        leadingLayoutAnchors.forEach { $0.apply(anchorPosition: position) }
        trailingLayoutAnchors.forEach { $0.apply(anchorPosition: position) }
    }
    
    func reset() {
        self.isSolved = false
        self.position = .zero
        leadingLayoutAnchors.forEach { $0.reset() }
        trailingLayoutAnchors.forEach { $0.reset() }
    }
}

class AdjacentLayoutAnchor {
    
    var width = Double(0)
    var distanceFromAnchor = Double(0)
    var offset = Double(0)
    var item: HorizontallyPositionable
    
    init(item: HorizontallyPositionable) {
        self.item = item
    }
    
    func trailingEdge(anchorPosition: Double) -> Double {
        return anchorPosition + offset + width/2
    }
    
    func apply(anchorPosition: Double) {
        self.item.xPosition = anchorPosition + offset
    }
    
    func reset() {
        offset = 0
    }
}

class CombinedItemsLayoutAnchor: LayoutAnchor {
  
    // LayoutAnchor
    var layoutAnchorType = LayoutAnchorType.unknown
    var enabled = true
    var leadingWidth: Double { anchors.map { $0.leadingWidth }.max()! }
    var trailingWidth: Double { anchors.map { $0.trailingWidth }.max()! }
    var trailingConstraints: [LayoutConstraint]
    var leadingConstraints: [LayoutConstraint]
    var position: Double = 0 {
        didSet {
            anchors.forEach { $0.position = position }
        }
    }
    var time: Time {
        return anchors.first!.time
    }
    var duration: Time?
    
    var leadingEdgeOffset: Double {
        let leftMostAnchors = anchors.compactMap { $0.leadingLayoutAnchors.last }
        if leftMostAnchors.isEmpty == false {
            return leftMostAnchors.map { $0.offset - $0.width/2 }.min()!
        } else {
            return -leadingWidth/2
        }
    }
    
    var trailingEdge: Double {
        let lastAnchors = anchors.compactMap { $0.trailingLayoutAnchors.last }
        if lastAnchors.isEmpty == false {
            return lastAnchors.map { $0.trailingEdge(anchorPosition: position) }.max()!
        } else {
            return position + trailingWidth/2
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
    
    func reset() {
        self.position = 0
        anchors.forEach { $0.reset() }
    }
}
