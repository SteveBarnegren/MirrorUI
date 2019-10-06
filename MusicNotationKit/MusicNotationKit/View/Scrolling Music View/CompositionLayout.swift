//
//  CompositionLayout.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

struct CompositionItem {
    let barRange: Range<Int>
    let size: Vector2<Double>
}

struct CompositionLayout {
    
    var compositionItems = [CompositionItem]()
    
    init(barSizes: [Vector2D], layoutWidth: Double) {
        
        var items = [CompositionItem]()
        
        var index = 0
        while let item = nextItem(from: barSizes, layoutWidth: layoutWidth, index: &index) {
            items.append(item)
        }
        
        compositionItems = items
    }
    
    private func nextItem(from barSizes: [Vector2D], layoutWidth: Double, index: inout Int) -> CompositionItem? {
        
        var currentWidth = Double(0)
        var currentHeight = Double(0)
        var numBars = 0
        
        func canAppendCurrentBar() -> Bool {
            if let width = barSizes[maybe: index]?.width {
                return numBars == 0 || currentWidth + width < layoutWidth
            } else {
                return false
            }
        }
        
        let rangeStart = index
        
        while canAppendCurrentBar() {
            currentWidth += barSizes[index].width
            currentHeight = max(currentHeight, barSizes[index].height)
            index += 1
            numBars += 1
        }
        
        if numBars > 0 {
            return CompositionItem(barRange: rangeStart..<rangeStart+numBars,
                                   size: Vector2(layoutWidth, currentHeight))
        } else {
            return nil
        }
    }
}
