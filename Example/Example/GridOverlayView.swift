//
//  GridOverlayView.swift
//  Example
//
//  Created by Steve Barnegren on 23/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import UIKit

class GridOverlayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.yellow.withAlphaComponent(0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawCenterLine()
    }
    
    func drawCenterLine() {

        UIColor.blue.withAlphaComponent(0.3).set()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.height/2))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height/2))
        path.stroke()
    }

}
