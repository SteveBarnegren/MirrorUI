import Foundation

class BarlineRenderer {

    private let metrics: FontMetrics

    init(metrics: FontMetrics) {
        self.metrics = metrics
    }
    
    func paths(forBarline barline: Barline) -> [Path] {

        let layout = BarlineLayout.layout(forBarline: barline, fontMetrics: metrics)
        var paths = [Path]()

        let height = 4.0 // Full stave height
        var xPos = barline.xPosition - (layout.width/2)

        for item in layout.items {
            switch item {
                case .space(let width):
                    xPos += width
                case .line(let width):
                    let rect = Rect(x: xPos,
                                    y: -height/2,
                                    width: width,
                                    height: height)
                    var path = Path(rect: rect)
                    path.drawStyle = .fill
                    paths.append(path)
                    xPos += width
            }
        }

        return paths
    }
}
