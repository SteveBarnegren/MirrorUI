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
            UIColor.blue.withAlphaComponent(0.5).set()
            let path = UIBezierPath()
            path.lineWidth = 0.5;
            path.move(to: CGPoint(x: CGFloat(itemDescription.xPosition), y: canvasSize.height))
            path.addLine(to: CGPoint(x: CGFloat(itemDescription.xPosition), y: 0))
            path.stroke()
        }
    }
}
