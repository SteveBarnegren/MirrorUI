//
//  LayoutAnchorsBuilder.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation
/*
class BarLayoutAnchorsStitcher {
    
    func stichAnchors(for bars: [Bar]) {
        
        for (bar, nextbar) in zip(bars, bars.dropFirst()) {
            let nextConstraints = danglingLeadingConstraints(forBar: nextbar)
            if let lastAnchor = bar.layoutAnchors.last {
                nextConstraints.forEach { $0.from = lastAnchor }
            }
            
            let thisConstraints = danglingTrailingConstraints(forBar: bar)
            if let firstAnchor = nextbar.layoutAnchors.first {
                thisConstraints.forEach { $0.to = firstAnchor }
            }
        }
    }
    
    private func danglingLeadingConstraints(forBar bar: Bar) -> [LayoutConstraint] {
        
        var constraints = [LayoutConstraint]()
        
        for anchor in bar.layoutAnchors {
            for constraint in anchor.leadingConstraints where constraint.from == nil {
                constraints.append(constraint)
            }
        }
        
        return constraints
    }
    
    private func danglingTrailingConstraints(forBar bar: Bar) -> [LayoutConstraint] {
        
        var constraints = [LayoutConstraint]()
        
        for anchor in bar.layoutAnchors {
            for constraint in anchor.trailingConstraints where constraint.to == nil {
                constraints.append(constraint)
            }
        }
        
        return constraints
    }
}
*/
