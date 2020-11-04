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
        
        draw(debugDrawCommands: pathBundle.debugDrawCommands)
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
            case .quadCurve(var p, var c1):
                p = invertY(p)
                c1 = invertY(c1)
                uiBezierPath.addQuadCurve(to: CGPoint(x: p.x, y: p.y), controlPoint: CGPoint(x: c1.x, y: c1.y))
            case .curve(var p, var c1, var c2):
                p = invertY(p)
                c1 = invertY(c1)
                c2 = invertY(c2)
                uiBezierPath.addCurve(to: p, controlPoint1: c1, controlPoint2: c2)
            case .close:
                uiBezierPath.close()
            case .circle(let p, let r):
                let point = invertY(p)
                let rect = CGRect(x: point.x - r,
                                  y: point.y - r,
                                  width: r*2,
                                  height: r*2)
                let circleBezierPath = UIBezierPath(ovalIn: rect)
                draw(uiBezierPath: circleBezierPath)
            case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                let point = invertY(center)
                uiBezierPath.addArc(withCenter: CGPoint(x: point.x, y: point.y),
                                    radius: CGFloat(radius),
                                    startAngle: CGFloat(startAngle),
                                    endAngle: CGFloat(endAngle),
                                    clockwise: clockwise)
            }
        }
        
        if uiBezierPath.isEmpty == false {
            draw(uiBezierPath: uiBezierPath)
        }
    }
    
    private func invertY(_ p: Vector2D) -> Vector2D {
        return Vector2D(p.x, Double(size.height) - p.y)
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
    
    private func draw(debugDrawCommands: [DebugDrawCommand]) {
        debugDrawCommands.forEach(draw)
    }
    
    private func draw(debugCommand: DebugDrawCommand) {
        
        if let line = debugCommand as? DebugDrawVerticalLine {
            line.color.set()
            let path = UIBezierPath()
            path.moveTo(CGFloat(line.xPos), 0)
            path.lineTo(CGFloat(line.xPos), y: size.height)
            path.lineWidth = 0.5
            
            if line.style == .dashed {
                let dashes: [CGFloat] = [2.0, 4.0]
                path.setLineDash(dashes, count: dashes.count, phase: 0.0)
            }
            
            path.stroke()
        } else if let region = debugCommand as? DebugDrawHorizontalRegion {
            region.color.set()
            let rect = CGRect(x: CGFloat(region.startX),
                              y: 0,
                              width: CGFloat(region.endX - region.startX),
                              height: size.height)
            let path = UIBezierPath(rect: rect)
            path.fill()
        }
    }
}
