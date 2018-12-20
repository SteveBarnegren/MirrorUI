//
//  MusicView.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import UIKit

public class MusicView: UIView {

    private var musicRenderer: MusicRenderer
    
    // MARK: - Init
    
    public init(composition: Composition) {
        self.musicRenderer = MusicRenderer(composition: composition)
        super.init(frame: .zero)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    
    override public func draw(_ rect: CGRect) {
        
        let displaySize = DisplaySize(Double(bounds.width), Double(bounds.height))
        
        for path in musicRenderer.paths(forDisplaySize: displaySize) {
            self.draw(path: path)
        }
    }
    
    func draw(path: Path) {
        
        UIColor.orange.set()
        
        let uiBezierPath = UIBezierPath()
        
        for command in path.commands {
            switch command {
            case .move(let p):
                uiBezierPath.move(to: p)
            case .line(let p):
                uiBezierPath.addLine(to: CGPoint(x: p.x, y: p.y))
            case .curve(let p, let c1, let c2):
                uiBezierPath.addCurve(to: p, controlPoint1: c1, controlPoint2: c2)
            case .close:
                uiBezierPath.close()
            }
        }
        
        switch path.drawStyle {
        case .stroke:
            uiBezierPath.stroke()
        case .fill:
            uiBezierPath.fill()
        }
    }
}
