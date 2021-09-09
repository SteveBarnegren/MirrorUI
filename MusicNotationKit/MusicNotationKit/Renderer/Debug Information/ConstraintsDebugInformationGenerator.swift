import Foundation
import UIKit

protocol DebugDrawCommand {
    func scaled(scale: Double) -> Self
}

enum DebugLineStyle {
    case regular
    case dashed
}

struct DebugDrawVerticalLine: DebugDrawCommand {
    var xPos: Double
    var color: UIColor
    var style = DebugLineStyle.regular
    
    func scaled(scale: Double) -> DebugDrawVerticalLine {
        var copy = self
        copy.xPos = copy.xPos * scale
        return copy
    }
}

struct DebugDrawHorizontalRegion: DebugDrawCommand {
    var startX: Double
    var endX: Double
    let color: UIColor
    
    func scaled(scale: Double) -> DebugDrawHorizontalRegion {
        var copy = self
        copy.startX = copy.startX * scale
        copy.endX = copy.endX * scale
        return copy
    }
}

class ConstraintsDebugInformationGenerator {
    
    func debugInformation(fromBars bars: [BarSlice], staveSpacing: Double) -> [DebugDrawCommand] {
        let layoutAnchors = bars.map { $0.layoutAnchors }.joined().filter { $0.enabled }.toArray()
        return commands(forLayoutAnchors: layoutAnchors).map { $0.scaled(scale: staveSpacing) }
 
    }
    
    private func commands(forLayoutAnchors layoutAnchors: [LayoutAnchor]) -> [DebugDrawCommand] {
        return layoutAnchors.map(commands).joined().toArray()
    }
    
    private func commands(forLayoutAnchor anchor: LayoutAnchor) -> [DebugDrawCommand] {
        
        var commands = [DebugDrawCommand]()
        
        // Horzontal Region for anchor width
        
//        let widthRegion = DebugDrawHorizontalRegion(startX: anchor.position - anchor.leadingWidth,
//                                                    endX: anchor.position + anchor.trailingWidth,
//                                                    color: UIColor.blue.withAlphaComponent(0.05))
//        commands.append(widthRegion)
        
        // Line at the center of the anchor
        let centerLine = DebugDrawVerticalLine(xPos: anchor.position, color: UIColor.blue.withAlphaComponent(0.5))
        commands.append(centerLine)
        
        // Dashed line at the start and end of the anchor region
        /*
        let regionEndColor = UIColor.blue.withAlphaComponent(0.3)
        var regionStart = DebugDrawVerticalLine(xPos: anchor.position - anchor.leadingWidth, color: regionEndColor)
        regionStart.style = .dashed
        commands.append(regionStart)
        
        var regionEnd = DebugDrawVerticalLine(xPos: anchor.position + anchor.trailingWidth, color: regionEndColor)
        regionEnd.style = .dashed
        commands.append(regionEnd)
        */
        return commands
    }
}
