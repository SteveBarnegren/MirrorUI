//
//  HorizontalLayoutItem.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

protocol HorizontalLayoutItemBase: class, HorizontallyPositionable {
    var horizontalLayoutWidth: Double { get }
}

protocol HorizontalLayoutItem: HorizontalLayoutItemBase {
    var layoutDuration: Time? { get }
    var leadingLayoutItems: [AdjacentLayoutItem] { get }
    var trailingLayoutItems: [AdjacentLayoutItem] { get }
}

protocol AdjacentLayoutItem: HorizontalLayoutItemBase {
    var hoizontalLayoutDistanceFromParentItem: Double { get }
}
