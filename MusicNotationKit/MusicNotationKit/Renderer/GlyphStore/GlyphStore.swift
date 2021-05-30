//
//  GlyphStore.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

enum GlyphType: String {
    
    // MARK: - Note Heads
    case noteheadBlack
    case noteheadWhole
    case noteheadHalf
    case noteheadXBlack

    // MARK: - Flags
    case flag8thUp
    
    // MARK: - Augmentation
    case augmentationDot
    
    // MARK: - Accidentals
    case accidentalFlat
    case accidentalNatural
    case accidentalSharp
    
    // MARK: - Clefs
    case gClef
    case fClef

    // MARK: - Rests
    case restWhole
    case restHalf
    case restQuarter
    case rest8th
    case rest16th
    case rest32nd
    case rest64th
    case rest128th
    case rest256th
    case rest512th
    case rest1024th
}

class Glyph {
    private var createPath: () -> Path
    
    private var _path: Path?
    var path: Path {
        if let p = _path {
            return p
        }
        
        let p = createPath()
        _path = p
        return p
    }
    
    private var _size: Vector2D?
    var size: Vector2D {
        if let s = _size {
            return s
        }
        
        let s = PathUtils.calculateSize(path: path)
        _size = s
        return s
    }
    
    var width: Double { size.width }
    var height: Double { size.height }
    
    init(createPath: @escaping () -> Path) {
        self.createPath = createPath
    }
    
    fileprivate var _stemUpSE: Lazy<Vector2D>!
    var stemUpSE: Vector2D { _stemUpSE.value }
    
    fileprivate var _stemUpNW: Lazy<Vector2D>!
    var stemUpNW: Vector2D { _stemUpNW.value }
    
    fileprivate var _stemDownNW: Lazy<Vector2D>!
    var stemDownNW: Vector2D { _stemDownNW.value }
}

class GlyphStore {
    
    let font: Font
    private var glyphs = [GlyphType: Glyph]() 
    
    var metrics: FontMetrics {
        return font.metrics
    }
    
    init(font: Font) {
        self.font = font
    }
    
    func glyph(forType type: GlyphType) -> Glyph {
        
        if let glyph = self.glyphs[type] {
            return glyph
        }
        
        let glyph = makeGlyph(type.rawValue)
        glyphs[type] = glyph
        return glyph
    }

    private func makeGlyph(_ name: String) -> Glyph {
        
        let font = self.font
        
        let glyph = Glyph(createPath: {
            let unicode = SMuFLSupport.shared.glyphs[name]!.unicode
            return TextPathCreator().path(forString: String(unicode),
                                          font: font.uiFont)
        })
        
        glyph._stemUpSE = Lazy {
            font.anchor(forGlyphName: name, anchorName: "stemUpSE") ?? .zero
        }
        
        glyph._stemUpNW = Lazy {
            font.anchor(forGlyphName: name, anchorName: "stemUpNW") ?? .zero
        }
        
        glyph._stemDownNW = Lazy {
            font.anchor(forGlyphName: name, anchorName: "stemDownNW") ?? .zero
        }
        
        return glyph
    }
}
