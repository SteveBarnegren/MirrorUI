import Foundation

struct CompositionItem {
    let barRange: Range<Int>
    var size: Vector2<Double>
    
    func with(height: Double) -> CompositionItem {
        return CompositionItem(barRange: barRange, size: Vector2(size.x, height))
    }
}

class CompositionLayout {
    
    var compositionItems = [CompositionItem]()
    
    // MARK: - Init
    
    init(barSizes: [BarSizingInfo], layoutWidth: Double) {
        
        var items = [CompositionItem]()
        
        var index = 0
        while let item = nextItem(from: barSizes, layoutWidth: layoutWidth, index: &index) {
            items.append(item)
        }
        
        compositionItems = items
    }
    
    private func nextItem(from barSizes: [BarSizingInfo], layoutWidth: Double, index: inout Int) -> CompositionItem? {
        
        var currentWidth = Double(0)
        var currentHeight = Double(0)
        var numBars = 0
        
        func barWidth() -> Double? {
            guard let size = barSizes[maybe: index] else { return nil }
            return numBars == 0 ? size.barSize.preferredWidthAsFirstBar : size.barSize.preferredWidth
        }
        
        func canAppendCurrentBar() -> Bool {
            if let width = barWidth() {
                return numBars == 0 || currentWidth + width < layoutWidth
            } else {
                return false
            }
        }
        
        let rangeStart = index
        
        while canAppendCurrentBar() {
            currentWidth += barWidth()!
            currentHeight = max(currentHeight, barSizes[index].minimumHeight)
            index += 1
            numBars += 1
        }
        
        if numBars > 0 {
            let itemWidth = index >= barSizes.count ? currentWidth : layoutWidth
            return CompositionItem(barRange: rangeStart..<rangeStart+numBars,
                                   size: Vector2(itemWidth, currentHeight))
        } else {
            return nil
        }
    }
    
    // MARK: - Update Item Heights
    
    func update(pathHeights: Double, forIndex index: Int, didUpdate: inout Bool) {
        
        var item = compositionItems[index]
        let existingHeight = item.size.height
        if pathHeights > existingHeight {
            item.size.height = pathHeights
            compositionItems[index] = item
            didUpdate = true
        } else {
            didUpdate = false
        }
    }
}

extension Array {
    
    mutating func mutate(range: Range<Int>, mutation: (Element) -> Element) {
        
        let copy = self.enumerated().map { (t) -> Element in
            if range.contains(t.offset) {
                return mutation(t.element)
            } else {
                return t.element
            }
        }
        self = copy
    }
}
