//
//  HorizontalLayoutItem.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

protocol HorizontalLayoutItem: class, HorizontallyPositionable {
    var layoutDuration: Time? { get }
    var leadingLayoutItems: [HorizontalLayoutItem] { get }
    var trailingLayoutItems: [HorizontalLayoutItem] { get }
}
