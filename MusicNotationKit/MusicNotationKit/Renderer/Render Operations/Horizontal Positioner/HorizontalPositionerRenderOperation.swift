import Foundation

class HorizontalPositionerRenderOperation {
    
    func process(bars: [BarSlice], layoutWidth: Double) {
        
        let anchors = bars.map { $0.layoutAnchors }
            .joined()
            .filter { $0.enabled }
            .toArray()
            .appending(maybe: bars.last?.trailingBarlineAnchor)
        
        HorizontalLayoutSolver().solve(anchors: anchors, layoutWidth: layoutWidth)
    }
}
