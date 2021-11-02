import Foundation

class BarlineRenderer {

    private let thinBarlineWidth: Double

    init(metrics: FontMetrics) {
        self.thinBarlineWidth = metrics.thinBarlineThickness
    }
    
    func paths(forBarline barline: Barline) -> [Path] {
        
        let width = thinBarlineWidth
        let height = 4.0
        
        let rect = Rect(x: barline.xPosition - width/2,
                        y: -height/2,
                        width: width,
                        height: height)
        
        var path = Path(rect: rect)
        path.drawStyle = .fill
        return [path]
    }

}
