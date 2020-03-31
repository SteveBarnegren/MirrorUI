//
//  PathBundleDrawer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 22/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

private let drawPathsBoundingBoxes = false

class PathBundleDrawer {
    
    private let size: CGSize
    
    init(size: CGSize) {
        self.size = size
    }
    
    func draw(pathBundle: PathBundle) {
        // Translate the paths to draw them in the correct place.
        let midY = Double(size.height/2)
        let drawOffset = (abs(pathBundle.minY) - abs(pathBundle.maxY))/2
        let paths = pathBundle.paths.map { $0.translated(x: 0, y: midY + drawOffset) }

        paths.forEach(draw)
        
        // Debug drawing
        if drawPathsBoundingBoxes {
            paths.forEach(drawBoundingBox)
        }
    }
    
    private func draw(path: Path) {
        
        UIColor.orange.set()
        
        let uiBezierPath = UIBezierPath()
        
        func draw(uiBezierPath: UIBezierPath) {
            switch path.drawStyle {
            case .stroke: uiBezierPath.stroke()
            case .fill: uiBezierPath.fill()
            }
        }
        
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
                draw(uiBezierPath: ovalBezierPath)
                
            case .circle(let p, let r):
                let point = invertY(p)
                let rect = CGRect(x: point.x - r,
                                  y: point.y - r,
                                  width: r*2,
                                  height: r*2)
                let circleBezierPath = UIBezierPath(ovalIn: rect)
                draw(uiBezierPath: circleBezierPath)
            }
        }
        
        if uiBezierPath.isEmpty == false {
            draw(uiBezierPath: uiBezierPath)
        }
    }
    
    private func invertY(_ p: Point) -> Point {
        return Point(p.x, Double(size.height) - p.y)
    }
    
    private func invertY(_ y: Double) -> Double {
        return Double(size.height) - y
    }
}

// MARK: - Debug Drawing

extension PathBundleDrawer {
    
    func drawBoundingBox(path: Path) {
        
        let rect = path.boundingBox
        let cgRect = CGRect(x: rect.x, y: invertY(rect.y) - rect.height, width: rect.width, height: rect.height)
        
        let uiBezierPath = UIBezierPath(rect: cgRect)
        
        UIColor.blue.withAlphaComponent(0.1).set()
        uiBezierPath.fill()
        
        UIColor.blue.withAlphaComponent(0.2).set()
        uiBezierPath.stroke()
    }
}
