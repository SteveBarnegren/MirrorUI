//
//  ConstraintsDebugView.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation
import UIKit

class ConstraintsDebugDrawer {
    
    func draw(debugInformation: ConstraintsDebugInformation, canvasSize: CGSize) {
        
        for itemDescription in debugInformation.descriptions {
            UIColor.blue.withAlphaComponent(0.3).set()
            let path = UIBezierPath()
            path.lineWidth = 0.5
            path.move(to: CGPoint(x: CGFloat(itemDescription.xPosition), y: canvasSize.height))
            path.addLine(to: CGPoint(x: CGFloat(itemDescription.xPosition), y: 0))
            path.stroke()
            
            for constraintZone in itemDescription.constraintZones {
                constraintZone.color.withAlphaComponent(0.1).set()
                let path = UIBezierPath(rect: CGRect(x: constraintZone.startX,
                                                     y: 0.0,
                                                     width: constraintZone.endX - constraintZone.startX,
                                                     height: Double(canvasSize.height)))
                path.fill()
            }
        }
    }
}
