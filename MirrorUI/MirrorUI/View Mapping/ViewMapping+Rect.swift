//
//  ViewMapping+Rect.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 27/02/2021.
//

import Foundation
import SwiftUI

protocol RectLike {
    func getX() -> String
    mutating func setX(_ string: String)
    func getY() -> String
    mutating func setY(_ string: String)
    func getWidth() -> String
    mutating func setWidth(_ string: String)
    func getHeight() -> String
    mutating func setHeight(_ string: String)
}

extension CGRect: RectLike {

    func getX() -> String {
        return origin.x.stringRepresentation
    }

    mutating func setX(_ string: String) {
        if let n = NumberFormatter().number(from: string).flatMap(CGFloat.init) {
            origin.x = n
        }
    }

    func getY() -> String {
        return origin.y.stringRepresentation
    }

    mutating func setY(_ string: String) {
        if let n = NumberFormatter().number(from: string).flatMap(CGFloat.init) {
            origin.y = n
        }
    }

    func getWidth() -> String {
        return size.width.stringRepresentation
    }

    mutating func setWidth(_ string: String) {
        if let n = NumberFormatter().number(from: string).flatMap(CGFloat.init) {
            size.width = n
        }
    }

    func getHeight() -> String {
        return size.height.stringRepresentation
    }

    mutating func setHeight(_ string: String) {
        if let n = NumberFormatter().number(from: string).flatMap(CGFloat.init) {
            size.height = n
        }
    }
}

extension ViewMapping {

    static let rectLike: ViewMapping = {

        let mapping = ViewMapping(for: RectLike.self) { ref, context in

            let xBinder = NumericEntryBinder(state: context.state,
                                             get: { ref.value.getX() },
                                             set: { ref.value.setX($0) },
                                             stateKey: "xText")

            let yBinder = NumericEntryBinder(state: context.state,
                                             get: { ref.value.getY() },
                                             set: { ref.value.setY($0) },
                                             stateKey: "yText")

            let wBinder = NumericEntryBinder(state: context.state,
                                             get: { ref.value.getWidth() },
                                             set: { ref.value.setWidth($0) },
                                             stateKey: "widthText")

            let hBinder = NumericEntryBinder(state: context.state,
                                             get: { ref.value.getHeight() },
                                             set: { ref.value.setHeight($0) },
                                             stateKey: "heightText")

            let view = HStack(alignment: .top) {
                Text(context.propertyName)
                Spacer()
                VStack(spacing: 4) {
                    HStack {
                        Text("x: ")
                        TextField("x", text: xBinder.textBinding, onCommit: { xBinder.commit() }).frame(maxWidth: 100)
                        Text("y: ")
                        TextField("y", text: yBinder.textBinding, onCommit: { yBinder.commit() }).frame(maxWidth: 100)
                    }
                    HStack {
                        Text("w: ")
                        TextField("w", text: wBinder.textBinding, onCommit: { wBinder.commit() }).frame(maxWidth: 100)
                        Text("h: ")
                        TextField("h", text: hBinder.textBinding, onCommit: { hBinder.commit() }).frame(maxWidth: 100)
                    }
                }
            }.focusSection()

            return view.asAnyView()
        }
        return mapping
    }()
}
