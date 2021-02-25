//
//  View.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 25/02/2021.
//

import Foundation
import SwiftUI

extension SwiftUI.View {

    func asAnyView() -> AnyView {
        return AnyView(self)
    }
}
