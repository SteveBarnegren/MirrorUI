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
    
    init(barWidths: [Double], layoutWidth: Double) {
        
        var items = [CompositionItem]()
        
        var index = 0
        while let item = nextItem(from: barWidths, layoutWidth: layoutWidth, index: &index) {
            items.append(item)
        }
        
        compositionItems = items
    }
    
    func nextItem(from barWidths: [Double], layoutWidth: Double, index: inout Int) -> CompositionItem? {
        
        var currentWidth = Double(0)
        var numBars = 0
        
        func canAppendCurrentBar() -> Bool {
            if let width = barWidths[maybe: index] {
                return numBars == 0 || currentWidth + width < layoutWidth
            } else {
                return false
            }
        }
        
        let rangeStart = index
        
        while canAppendCurrentBar() {
            currentWidth += barWidths[index]
            index += 1
            numBars += 1
        }
        
        if numBars > 0 {
            return CompositionItem(barRange: rangeStart..<rangeStart+numBars,
                                   size: Vector2(layoutWidth, 100))
        } else {
            return nil
        }
    }
}
