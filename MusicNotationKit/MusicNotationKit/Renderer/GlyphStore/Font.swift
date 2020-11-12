//
//  Font.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 12/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class Font {
    
    let name: String
    let uiFont: UIFont
    let metadata: [String: Any]
    
    init(name: String, metadata: [String: Any]) {
        self.name = name
        self.uiFont = UIFont(name: name, size: 4)!
        self.metadata = metadata
    }
}

// MARK: - Anchors

extension Font {
    
    func anchor(forGlyphName glyphName: String, anchorName: String) -> Vector2D? {
        
        guard let anchorsDict = metadata["glyphsWithAnchors"] as? [String: Any] else {
            return nil
        }
        
        guard let glyphDict = anchorsDict[glyphName] as? [String: Any] else {
            return nil
        }
        
        guard let stemUpSEArray = glyphDict[anchorName] as? [Double] else {
            return nil
        }
        
        guard let x = stemUpSEArray[maybe: 0], let y = stemUpSEArray[maybe: 1] else {
            return nil
        }
        
        return Vector2D(x, y)
    }
    
}
