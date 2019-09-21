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
    
    public var _showConstraintsDebug = false {
        didSet {
            musicRenderer._generateConstraintsDebugInformation = _showConstraintsDebug
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Init
    
    public init(composition: Composition) {
        self.musicRenderer = MusicRenderer(composition: composition)
        self.musicRenderer.preprocessComposition()
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
        
        // Debug
        if _showConstraintsDebug, let debugInformation = musicRenderer._constraintsDebugInformation {
            ConstraintsDebugDrawer().draw(debugInformation: debugInformation, canvasSize: bounds.size)
        }
    }
    
    func draw(path: Path) {
        
        UIColor.orange.set()
        
        let uiBezierPath = UIBezierPath()
        
        for command in path.commands {
            switch command {
            case .move(var p):
                p = invertY(p)
                uiBezierPath.move(to: p)
            case .line(var p):
                p = invertY(p)
                uiBezierPath.addLine(to: CGPoint(x: p.x, y: p.y))
            case .curve(var p, var c1, var c2):
                p = invertY(p)
                c1 = invertY(c1)
                c2 = invertY(c2)
                uiBezierPath.addCurve(to: p, controlPoint1: c1, controlPoint2: c2)
            case .close:
                uiBezierPath.close()
            case .oval(var point, let size, let rotation):
                point = invertY(point)
                let cgRect = CGRect(x: CGFloat(point.x - size.width/2),
                                    y: CGFloat(point.y - size.height/2),
                                    width: CGFloat(size.width),
                                    height: CGFloat(size.height))
                let ovalBezierPath = UIBezierPath(ovalIn: cgRect)
                
                let translateToOrgin = CGAffineTransform(translationX: CGFloat(-point.x),
                                                         y: CGFloat(-point.y))
                let rotate = CGAffineTransform(rotationAngle: CGFloat(rotation))
                let translateBack = CGAffineTransform(translationX: CGFloat(point.x),
                                                      y: CGFloat(point.y))

                let fullTransform = translateToOrgin.concatenating(rotate).concatenating(translateBack)
                ovalBezierPath.apply(fullTransform)
                
                switch path.drawStyle {
                case .stroke:
                    ovalBezierPath.stroke()
                case .fill:
                    ovalBezierPath.fill()
                }
            }
        }
        
        if uiBezierPath.isEmpty == false {
            switch path.drawStyle {
            case .stroke:
                uiBezierPath.stroke()
            case .fill:
                uiBezierPath.fill()
            }
        }
    }
    
    private func invertY(_ p: Point) -> Point {
        return Point(p.x, Double(bounds.height) - p.y)
    }
    
}


