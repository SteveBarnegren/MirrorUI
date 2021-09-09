import Foundation

class VectorMath {
    
    enum Orientation {
        case clockwise
        case counterClockwise
        case colinear
    }
    
    static func orientation(_ p1: Vector2D, _ p2: Vector2D, _ p3: Vector2D) -> Orientation {
        
        let value = (p2.y - p1.y) * (p3.x - p2.x) - (p2.x - p1.x) * (p3.y - p2.y)
        
        if value == 0 {
            return .colinear
        } else {
            return value > 0 ? .clockwise : .counterClockwise
        }
    }
    
    // p1 -> start1 | q1 -> end1 | p2 -> start2 | q2 -> end2
    static func lineSegmentsIntersect(start1: Vector2D,
                                      end1: Vector2D,
                                      start2: Vector2D,
                                      end2: Vector2D) -> Bool {
        
        // Given three colinear points p, q, r, the function checks if
        // point q lies on line segment 'pr'
        func onSegment(_ p: Vector2D, _ q: Vector2D, _ r: Vector2D) -> Bool {
            return  q.x <= max(p.x, r.x) && q.x >= min(p.x, r.x) && q.y <= max(p.y, r.y) && q.y >= min(p.y, r.y)
        }
        
        // Find the four orientations needed for general and
        // special cases
        let o1 = orientation(start1, end1, start2)
        let o2 = orientation(start1, end1, end2)
        let o3 = orientation(start2, end2, start1)
        let o4 = orientation(start2, end2, end1)
        
        // General case
        if o1 != o2 && o3 != o4 {
            return true
        }
        
        // Special Cases
        // start1, end1 and start2 are colinear and start2 lies on segment start1 -> end1
        if o1 == .colinear && onSegment(start1, start2, end1) { return true }
        
        // start1, end1 and start2 are colinear and end2 lies on segment start1 -> end1
        if o2 == .colinear && onSegment(start1, end2, end2) { return true }
        
        // start2, end2 and start1 are colinear and start1 lies on segment start2 -> end2
        if o3 == .colinear && onSegment(start2, start1, end2) { return true }
        
        // start2, end2 and end1 are colinear and end1 lies on segment start2 -> end2
        if o4 == .colinear && onSegment(start2, end1, end2) { return true }
        
        return false // Doesn't fall in any of the above cases
    }
    
}
