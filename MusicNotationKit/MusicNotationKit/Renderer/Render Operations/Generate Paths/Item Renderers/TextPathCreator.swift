import Foundation

class TextPathCreator {
    
    func path(forString string: String, font: UIFont, spacing: Double = 0.05) -> Path {

        var unichars = [UniChar](string.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        
        if gotGlyphs == false {
            return Path()
        }
        
        var commands = [Path.Command]()
        
        // For a multi-character string, place each glyph next to the last
        if unichars.count > 1 {
            let characterSpacing = 0.05 * Double(font.pointSize)

            var xPos = 0.0
            for i in 0..<unichars.count {
                let glyphCommands = CTFontCreatePathForGlyph(font, glyphs[i], nil)!.pathCommands
                commands += glyphCommands.translated(x: xPos, y: 0)
                xPos += glyphCommands.width() + characterSpacing
            }
        }
        // For a single character string we can skip this and just return the commands
        else {
            commands = CTFontCreatePathForGlyph(font, glyphs[0], nil)!.pathCommands
        }
        
        var path = Path(commands: commands)
        path.drawStyle = .fill
        return path
    }
}
