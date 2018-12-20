//
//  MusicView.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import UIKit

public class MusicView: UIView {

    let staveSpacing = Double(40)
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    
    override public func draw(_ rect: CGRect) {
        drawStave()
        drawBarLines()
        drawAWholeNote()
    }
    
    func drawStave() {
        
        UIColor.black.set()
        
        let midY = Double(bounds.height)/2
        let numberOfLines = 5
        let staveHeight = Double(numberOfLines-1) * staveSpacing
        
        // Draw the horizontal lines
        var y = midY - staveHeight/2
        for _ in (0..<numberOfLines) {
            let path = UIBezierPath()
            path.moveTo(0, y)
            path.lineTo(Double(bounds.width), y: y)
            path.stroke()
            y += staveSpacing
        }
    }
    
    func drawBarLines() {
        
        UIColor.black.set()
        
        let midY = Double(bounds.height)/2
        let numberOfLines = 5
        let staveHeight = Double(numberOfLines-1) * staveSpacing
        
        // Draw the left line
        let leftPath = UIBezierPath()
        leftPath.moveTo(0, midY - staveHeight/2)
        leftPath.lineTo(0, y: midY + staveHeight/2)
        leftPath.stroke()
        
        // Draw the right line
        let rightPath = UIBezierPath()
        rightPath.moveTo(Double(bounds.width), midY - staveHeight/2)
        rightPath.lineTo(Double(bounds.width), y: midY + staveHeight/2)
        rightPath.stroke()
    }
    
    func drawAWholeNote() {
        draw(notePath: semibrevePath, atStaveOffset: -4, xPos: 30)
        
        let commands: [Path.Command] = [
            .move(Point(0, 0)),
            .curve(Point(1, 0),
                   c1: Point(0, 0),
                   c2: Point(1, 0)),
            .curve(Point(1, 1),
                   c1: Point(1, 0),
                   c2: Point(1, 1)),
            .curve(Point(0, 1),
                   c1: Point(1, 1),
                   c2: Point(0, 1)),
            .close,
            ]
        let squarePath = Path(commands: commands)
        
        draw(notePath: squarePath, atStaveOffset: -4, xPos: 100)
        
        //draw(path: semibrevePath)
    }
    
    func draw(notePath: Path, atStaveOffset staveOffset: Int, xPos: Double) {
        
        let centerY = Double(bounds.height/2) + (Double(staveOffset) * staveSpacing/2)
        let scale = staveSpacing
        
        UIColor.blue.set()
        
        func transformPoint(_ p: Point) -> Point {
            return Point(xPos + (p.x * scale), centerY + (p.y * scale))
        }
        
        let uiBezierPath = UIBezierPath()
        
        for command in notePath.commands {
            switch command {
            case .move(let p):
                uiBezierPath.move(to: transformPoint(p))
            case .curve(let p, let c1, let c2):
                uiBezierPath.addCurve(to: transformPoint(p),
                                      controlPoint1: transformPoint(c1),
                                      controlPoint2: transformPoint(c2))
            case .close:
                uiBezierPath.close()
            }
        }
        
        uiBezierPath.fill()
    }
    
    func draw(path: Path) {
        
        UIColor.blue.set()
        
        let uiBezierPath = UIBezierPath()
        
        for command in path.commands {
            switch command {
            case .move(let p):
                uiBezierPath.move(to: p)
            case .curve(let p, let c1, let c2):
                uiBezierPath.addCurve(to: p, controlPoint1: c1, controlPoint2: c2)
            case .close:
                uiBezierPath.close()
            }
        }
        
        uiBezierPath.fill()
    }
    
    
    
    
    
    
}
