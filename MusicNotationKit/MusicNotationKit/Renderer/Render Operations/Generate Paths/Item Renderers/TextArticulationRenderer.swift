//
//  TextArticulationRenderer.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 17/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class TextArticulationRenderer {

    func paths(forTextArticulation articulation: TextArticulation, xPos: Double, scale: Double) -> [Path] {

        let textPath = self.textPath(forText: articulation.text)
        let path = textPath.path
            .scaled(scale)
            .translated(x: xPos, y: articulation.yPosition)
        return [path]
    }

    private func textPath(forText string: String) -> TextPath {

//        if let cachedPath = textCache.value(forKey: string) {
//            return cachedPath
//        }

        let font = UIFont.systemFont(ofSize: 1, weight: .bold)
        var path = TextPathCreator().path(forString: string, font: font)
        path = PathUtils.centered(path: path)

        let textPath = TextPath(path: path)
        //textCache.set(value: textPath, forKey: string)
        return textPath
    }
}
