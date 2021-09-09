import Foundation

class StaveRenderer {
    
    static func stavePaths(withWidth staveWidth: Double, style: StaveStyle) -> [Path] {
     
        let numberOfLines: Int
        switch style {
            case .fiveLine:
                numberOfLines = 5
            case .singleLine:
                numberOfLines = 1
        }

        let totalStaveHeight = Double(numberOfLines-1)
    
        var paths = [Path]()
        
        var y = -totalStaveHeight/2
        for _ in (0..<numberOfLines) {
            
            let commands: [Path.Command] = [
                .move(Vector2D(0, y)),
                .line(Vector2D(staveWidth, y))
            ]
            
            var path = Path(commands: commands)
            path.drawStyle = .stroke
            paths.append(path)
            y += 1
        }
        
        return paths
    }
}
