import Foundation

// A BarlineLayout consists of multiple BarlineLayoutItems rendered horizontally
enum BarlineLayoutItem {
    case space(Double)
    case line(width: Double)

    var width: Double {
        switch self {
            case .space(let w):
                return w
            case .line(width: let w):
                return w
        }
    }
}

class BarlineLayout {

    private let lineType: Barline.LineType
    private let fontMetrics: FontMetrics
    private(set) var items = [BarlineLayoutItem]()
    lazy var width: Double = items.sum(\.width)

    init(lineType: Barline.LineType, fontMetrics: FontMetrics) {
        self.lineType = lineType
        self.fontMetrics = fontMetrics
        self.items = self.createLayoutItems()
    }

    private func createLayoutItems() -> [BarlineLayoutItem] {
        var items = [BarlineLayoutItem]()
        switch lineType {
            case .single:
                items.append(makeThinBarline())
            case .double:
                items.append(
                    makeThinBarline(),
                    .space(fontMetrics.barlineSeparation),
                    makeThinBarline()
                )
            case .final:
                items.append(
                    makeThinBarline(),
                    .space(fontMetrics.barlineSeparation),
                    makeThickBarline()
                )
        }
        return items
    }

    private func makeThinBarline() -> BarlineLayoutItem {
        return .line(width: fontMetrics.thinBarlineThickness)
    }

    private func makeThickBarline() -> BarlineLayoutItem {
        return .line(width: fontMetrics.thickBarlineThickness)
    }
}

extension BarlineLayout {

    static func layout(forBarline barline: Barline,
                fontMetrics: FontMetrics) -> BarlineLayout {
        return BarlineLayout(lineType: barline.lineType,
                             fontMetrics: fontMetrics)
    }
}
