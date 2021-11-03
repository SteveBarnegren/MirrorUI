import Foundation

class BarlineRenderer {

    private let glyphs: GlyphStore

    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func paths(forBarline barline: Barline) -> [Path] {

        let layout = BarlineLayout(barline: barline, glyphs: glyphs)
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
                case .repeatLeft(width: let width):
                    var path = glyphs.glyph(forType: .repeatDots).path
                    path.translate(x: xPos, y: -2) // Origin is below dots, so they need to be centered
                    paths.append(path)
                    xPos += width
                case .repeatRight(width: let width):
                    var path = glyphs.glyph(forType: .repeatDots).path
                    path.translate(x: xPos, y: -2) // Origin is below dots, so they need to be centered
                    paths.append(path)
                    xPos += width
            }
        }

        return paths
    }
}
