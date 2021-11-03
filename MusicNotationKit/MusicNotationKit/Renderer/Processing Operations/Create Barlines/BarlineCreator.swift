import Foundation

// Creates a shared barline that satisfies the barline options of two adjacent
// barlines.
class BarlineCreator {

    func createBarline(leadingOptions: BarlineOptions?, trailingOptions: BarlineOptions?) -> Barline {
        var lineType = Barline.LineType.single
        if trailingOptions?.contains(.double) == true {
            lineType = .double
        }

        if leadingOptions?.contains(.final) == true {
            lineType = .final
        }

        let barline = Barline()
        barline.lineType = lineType
        return barline
    }
}
