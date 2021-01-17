//
//  Settings.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 09/01/2021.
//

import Foundation
import SwiftUI
import MirrorUI

enum Level: CaseIterable {
    case low
    case medium
    case high
}

class Settings {
    
    static let shared = Settings()
    
    @MirrorUI var shadowEnabled = false
    @MirrorUI var blurEnabled = false
    @MirrorUI(range: 0...20) var blurAmount = 5.3
    @MirrorUI var shadowOpacity = 4.6
    @MirrorUI var level = Level.low
    
    init() {
        $shadowEnabled.didSet = {
            print("shadow enabled didset callback: \($0)")
        }
        
        $blurAmount.didSet = {
            print("Blur amount updated: \($0)")
        }
    }
}

class Ref<T> {
    var didSet: (T) -> Void = { _ in}
    
    var value: T {
        didSet { didSet(value) }
    }
    init(value: T) {
        self.value = value
    }
}


