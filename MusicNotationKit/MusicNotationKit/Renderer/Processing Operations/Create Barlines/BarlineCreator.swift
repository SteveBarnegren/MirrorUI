import Foundation

// Creates a shared barline that satisfies the barline options of two adjacent
// barlines.
class BarlineCreator {

    func createBarline(leadingOptions: BarlineOptions?, trailingOptions: BarlineOptions?) -> Barline {
        // Work out the line type
        var lineType = Barline.LineType.single
        if trailingOptions?.contains(.double) == true {
            lineType = .double
        }

        if leadingOptions?.contains(.final) == true {
            lineType = .final
        }

        // Work out if there are any repeats
        let shouldRepeatLeft = (leadingOptions?.contains(.endRepeat) == true)
        let shouldRepeatRight = (trailingOptions?.contains(.startRepeat) == true)

        let barline = Barline()
        barline.lineType = lineType
        barline.repeatLeft = shouldRepeatLeft
        barline.repeatRight = shouldRepeatRight
        return barline
    }
}
