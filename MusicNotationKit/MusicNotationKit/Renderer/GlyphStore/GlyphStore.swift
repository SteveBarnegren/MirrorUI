import Foundation

enum GlyphType: String {
    
    // MARK: - Note Heads
    case noteheadBlack
    case noteheadWhole
    case noteheadHalf
    case noteheadXBlack

    // MARK: - Flags
    case flag8thUp
    case flag8thDown
    case flag16thUp
    case flag16thDown
    case flag32ndUp
    case flag32ndDown
    case flag64thUp
    case flag64thDown
    case flag128thUp
    case flag128thDown
    case flag256thUp
    case flag256thDown
    case flag512thUp
    case flag512thDown
    case flag1024thUp
    case flag1024thDown

    // MARK: - Augmentation
    case augmentationDot
    case graceNoteSlashStemUp
    
    // MARK: - Accidentals
    case accidentalFlat
    case accidentalNatural
    case accidentalSharp
    
    // MARK: - Clefs
    case gClef
    case fClef
    case unpitchedPercussionClef1

    // MARK: - Repeats
    case repeatDots

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

    // MARK: - Time Signatures
    case timeSig0
    case timeSig1
    case timeSig2
    case timeSig3
    case timeSig4
    case timeSig5
    case timeSig6
    case timeSig7
    case timeSig8
    case timeSig9

    // MARK: - Tremolo
    case tremolo1
    case tremolo2
    case tremolo3
    case tremolo4
    case tremolo5
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

    fileprivate var _stemDownSW: Lazy<Vector2D>!
    var stemDownSW: Vector2D { _stemDownSW.value }
    
    fileprivate var _stemDownNW: Lazy<Vector2D>!
    var stemDownNW: Vector2D { _stemDownNW.value }

    fileprivate var _graceNoteSlashSW: Lazy<Vector2D>!
    var graceNoteSlashSW: Vector2D { _graceNoteSlashSW.value }
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

        glyph._stemDownSW = Lazy {
            font.anchor(forGlyphName: name, anchorName: "stemDownSW") ?? .zero
        }
        
        glyph._stemDownNW = Lazy {
            font.anchor(forGlyphName: name, anchorName: "stemDownNW") ?? .zero
        }

        glyph._graceNoteSlashSW = Lazy {
            font.anchor(forGlyphName: name, anchorName: "graceNoteSlashSW") ?? .zero
        }
        
        return glyph
    }
}
