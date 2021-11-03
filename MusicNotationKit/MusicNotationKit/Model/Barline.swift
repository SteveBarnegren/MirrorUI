import Foundation

class Barline: HorizontalLayoutItem {

    enum LineType {
        case single
        case double
        case final
    }

    var lineType = LineType.single
    var repeatLeft = false
    var repeatRight = false
         
    // HorizontalLayoutItem
    let layoutDuration: Time? = nil
    let leadingChildItems = [AdjacentLayoutItem]()
    let trailingChildItems = [AdjacentLayoutItem]()
    lazy var horizontalLayoutWidth = HorizontalLayoutWidthType.custom { [weak self] glyphStore in
        let width = self.flatMap { BarlineLayout(barline: $0, glyphs: glyphStore) }?.width ?? 0
        return (leading: width/2, trailing: width/2)
    }
    
    // HorizontallyPositionable
    var xPosition = Double(0)
}
