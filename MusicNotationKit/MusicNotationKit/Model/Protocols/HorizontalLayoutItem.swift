//
//  HorizontalLayoutItem.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

enum HorizontalLayoutWidthType {
    case centered(width: Double)
    case offset(leading: Double, trailing: Double)
}

protocol HorizontalLayoutItemBase: class, HorizontallyPositionable {
    var horizontalLayoutWidth: HorizontalLayoutWidthType { get }
}

extension HorizontalLayoutItemBase {
    var leadingWidth: Double {
        switch horizontalLayoutWidth {
        case .centered(let width):
            return width/2
        case .offset(let leading, _):
            return leading
        }
    }
    
    var trailingWidth: Double {
        switch horizontalLayoutWidth {
        case .centered(let width):
            return width/2
        case .offset(_, let trailing):
            return trailing
        }
    }
}

protocol HorizontalLayoutItem: HorizontalLayoutItemBase {
    var layoutDuration: Time? { get }
    var leadingLayoutItems: [AdjacentLayoutItem] { get }
    var trailingLayoutItems: [AdjacentLayoutItem] { get }
}

protocol AdjacentLayoutItem: HorizontalLayoutItemBase {
    var hoizontalLayoutDistanceFromParentItem: Double { get }
}
