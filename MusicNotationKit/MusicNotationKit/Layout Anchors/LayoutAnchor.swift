import Foundation

enum LayoutAnchorContent {
    case unknown
    case leadingClef
    case timeSignature
    
    var visibleInFirstBarOfLineOnly: Bool {
        switch self {
        case .leadingClef:
            return true
        default:
            return false
        }
    }
}

// MARK: - ******* Layout Anchor ********

class LayoutAnchor {
    var enabled = true
    var content = LayoutAnchorContent.unknown
    var leadingWidth: Double { 0 }
    var trailingWidth: Double { 0 }
    var leadingConstraints = [LayoutConstraint]()
    var trailingConstraints = [LayoutConstraint]()
    var position = Double.zero {
        didSet {
            assert(!position.isNaN)
            assert(!position.isInfinite)
            onPositionUpdated()
        }
    }
    var leadingEdgeOffset: Double { Double.zero }
    var trailingEdge: Double { Double.zero }
    var duration: Time?
    var barTime: Time { .zero }
    
    func reset() {
        enabled = true
    }
    func apply() {}
    
    func add(leadingConstraint: LayoutConstraint) {
        self.leadingConstraints.append(leadingConstraint)
    }
    
    func add(trailingConstraint: LayoutConstraint) {
        self.trailingConstraints.append(trailingConstraint)
    }
    
    // Sublass hooks
    func onPositionUpdated() {}
}

final class SingleItemLayoutAnchor: LayoutAnchor {
  
    // LayoutAnchor
    var isSolved = false
    var leadingChildAnchors = [AdjacentLayoutAnchor]()
    var trailingChildAnchors = [AdjacentLayoutAnchor]()
    
    private var _barTime: Time
    override var barTime: Time { _barTime }
    
    private var _leadingWidth: Double
    override var leadingWidth: Double { _leadingWidth }
    private var _trailingWidth: Double
    override var trailingWidth: Double { _trailingWidth }
    
    override var leadingEdgeOffset: Double {
        if let leftMostLeadingAnchor = leadingChildAnchors.last {
            return leftMostLeadingAnchor.offset - leftMostLeadingAnchor.width/2
        } else {
            return -leadingWidth
        }
    }
    
    override var trailingEdge: Double {
        if let lastTrailingAnchor = trailingChildAnchors.last {
            return lastTrailingAnchor.trailingEdge(anchorPosition: position)
        } else {
            return position + trailingWidth
        }
    }
    
    var item: HorizontallyPositionable
    
    init(item: HorizontallyPositionable, leadingWidth: Double, trailingWidth: Double, barTime: Time = .zero) {
        self.item = item
        self._leadingWidth = leadingWidth
        self._trailingWidth = trailingWidth
        self._barTime = barTime
        super.init()
    }
    
    func add(trailingAnchor: AdjacentLayoutAnchor) {
        self.trailingChildAnchors.append(trailingAnchor)
    }
    
    func add(leadingAnchor: AdjacentLayoutAnchor) {
        self.leadingChildAnchors.append(leadingAnchor)
    }
    
    override func apply() {
        self.item.xPosition = self.position
        leadingChildAnchors.forEach { $0.apply(anchorPosition: position) }
        trailingChildAnchors.forEach { $0.apply(anchorPosition: position) }
    }
    
    override func reset() {
        self.isSolved = false
        self.position = .zero
        leadingChildAnchors.forEach { $0.reset() }
        trailingChildAnchors.forEach { $0.reset() }
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
    
    override func onPositionUpdated() {
        anchors.forEach { $0.position = position }
    }
  
    // LayoutAnchor
    override var leadingWidth: Double { anchors.map { $0.leadingWidth }.max()! }
    override var trailingWidth: Double { anchors.map { $0.trailingWidth }.max()! }
    override var barTime: Time {
        return anchors.first!.barTime
    }
    
    override var leadingEdgeOffset: Double {
        let leftMostAnchors = anchors.compactMap { $0.leadingChildAnchors.last }
        if !leftMostAnchors.isEmpty {
            return leftMostAnchors.map { $0.offset - $0.width/2 }.min()!
        } else {
            return -leadingWidth
        }
    }
    
    override var trailingEdge: Double {
        let lastAnchors = anchors.compactMap { $0.trailingChildAnchors.last }
        if lastAnchors.isEmpty == false {
            return lastAnchors.map { $0.trailingEdge(anchorPosition: position) }.max()!
        } else {
            return position + trailingWidth
        }
    }
    
    let anchors: [SingleItemLayoutAnchor]
    
    init(anchors: [SingleItemLayoutAnchor]) {
        self.anchors = anchors
        super.init()
        self.leadingConstraints = anchors.map { $0.leadingConstraints }.joined().toArray()
        self.trailingConstraints = anchors.map { $0.trailingConstraints }.joined().toArray()
    }
    
    override func apply() {
        for anchor in anchors {
            anchor.position = position
            anchor.apply()
        }
    }
    
    override func reset() {
        self.position = 0
        anchors.forEach { $0.reset() }
    }
}
