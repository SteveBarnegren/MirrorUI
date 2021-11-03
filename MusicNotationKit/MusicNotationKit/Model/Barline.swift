import Foundation

class Barline: HorizontalLayoutItem {

    enum LineType {
        case single
        case double
    }

    var lineType = LineType.single
    
    // HorizontalLayoutItem
    let layoutDuration: Time? = nil
    let leadingChildItems = [AdjacentLayoutItem]()
    let trailingChildItems = [AdjacentLayoutItem]()
    lazy var horizontalLayoutWidth = HorizontalLayoutWidthType.custom { [weak self] glyphStore in
        let width = BarlineLayout(lineType: self?.lineType ?? .single,
                                  fontMetrics: glyphStore.metrics).width
        return (leading: width/2, trailing: width/2)
    }
    
    // HorizontallyPositionable
    var xPosition = Double(0)
}
