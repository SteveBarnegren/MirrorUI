import Foundation

class Barline: HorizontalLayoutItem {
    
    // HorizontalLayoutItem
    let layoutDuration: Time? = nil
    let leadingChildItems = [AdjacentLayoutItem]()
    let trailingChildItems = [AdjacentLayoutItem]()
    lazy var horizontalLayoutWidth = HorizontalLayoutWidthType.custom { glyphStore in
        let width = glyphStore.metrics.thinBarlineThickness
        return (leading: width/2, trailing: width/2)
    }
    
    // HorizontallyPositionable
    var xPosition = Double(0)
}
