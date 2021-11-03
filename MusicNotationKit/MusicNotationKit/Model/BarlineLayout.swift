import Foundation

// A BarlineLayout consists of multiple BarlineLayoutItems rendered horizontally
enum BarlineLayoutItem {
    case space(Double)
    case line(width: Double)
    case repeatLeft(width: Double)
    case repeatRight(width: Double)

    var width: Double {
        switch self {
            case .space(let w):
                return w
            case .line(width: let w):
                return w
            case .repeatLeft(let w):
                return w
            case .repeatRight(let w):
                return w
        }
    }
}

class BarlineLayout {

    private(set) var items = [BarlineLayoutItem]()
    lazy var width: Double = items.sum(\.width)

    init(barline: Barline, glyphs: GlyphStore) {
        self.items = self.createLayoutItems(lineType: barline.lineType,
                                            repeatleft: barline.repeatLeft,
                                            repeatRight: barline.repeatRight,
                                            glyphs: glyphs)
    }

    private func createLayoutItems(lineType: Barline.LineType,
                                   repeatleft: Bool,
                                   repeatRight: Bool,
                                   glyphs: GlyphStore) -> [BarlineLayoutItem] {
        let metrics = glyphs.metrics

        var items = [BarlineLayoutItem]()

        // Repeat left
        if repeatleft {
            items.append(
                .repeatLeft(width: glyphs.glyph(forType: .repeatDots).width),
                .space(metrics.repeatBarlineDotSeparation)
            )

        }

        // Lines
        let thinBarline = BarlineLayoutItem.line(width: metrics.thinBarlineThickness)
        let thickBarline = BarlineLayoutItem.line(width: metrics.thickBarlineThickness)

        switch lineType {
            case .single:
                items.append(thinBarline)
            case .double:
                items.append(
                    thinBarline,
                    .space(metrics.barlineSeparation),
                    thinBarline
                )
            case .final:
                items.append(
                    thinBarline,
                    .space(metrics.barlineSeparation),
                    thickBarline
                )
        }

        // Repeat right
        if repeatRight {
            items.append(
                .space(metrics.repeatBarlineDotSeparation),
                .repeatRight(width: glyphs.glyph(forType: .repeatDots).width)
            )
        }

        return items
    }
}
