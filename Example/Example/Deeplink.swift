//
//  Deeplink.swift
//  Example
//
//  Created by Steve Barnegren on 22/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

enum DeepLink {
    case component(ComponentDeepLink)
}

enum ComponentDeepLink {
    case notes
    case rests
    case intervalsAndChords
    case accidentals
}
