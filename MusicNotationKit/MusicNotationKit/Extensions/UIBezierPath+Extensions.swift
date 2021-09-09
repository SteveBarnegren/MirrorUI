import Foundation
import UIKit

extension UIBezierPath {
    
    func move(to point: Vector2D) {
        self.move(to: CGPoint(point))
    }
    
    func addCurve(to point: Vector2D, controlPoint1: Vector2D, controlPoint2: Vector2D) {
        self.addCurve(to: CGPoint(point), controlPoint1: CGPoint(controlPoint1), controlPoint2: CGPoint(controlPoint2))
    }

    func moveTo(_ x: CGFloat, _ y: CGFloat) {
        self.move(to: CGPoint(x: x, y: y))
    }
    
    func lineTo(_ x: CGFloat, y: CGFloat) {
        self.addLine(to: CGPoint(x: x, y: y))
    }
    
    func moveTo(_ x: Double, _ y: Double) {
        self.move(to: CGPoint(x: x, y: y))
    }
    
    func lineTo(_ x: Double, y: Double) {
        self.addLine(to: CGPoint(x: x, y: y))
    }
}
