//
//  ViewMapping+Rect.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 27/02/2021.
//

import Foundation
import SwiftUI

extension ViewMapping {

    static let rectLike: ViewMapping = {
        let mapping = ViewMapping(for: RectLike.self) { ref, context in
            return Text("Rect like").asAnyView()
        }
        return mapping
    }()
}
