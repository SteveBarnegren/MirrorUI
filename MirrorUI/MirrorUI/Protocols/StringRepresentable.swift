//
//  StringRepresentable.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 25/02/2021.
//

import Foundation

protocol StringRepresentable {
    init?(stringRepresentation: String)
    var stringRepresentation: String { get }
}

extension StringRepresentable {
    var stringRepresentation: String {
        "\(self)"
    }
}

extension String: StringRepresentable {

    init?(stringRepresentation: String) {
        self = stringRepresentation
    }

    var stringRepresentation: String {
        return self
    }
}
