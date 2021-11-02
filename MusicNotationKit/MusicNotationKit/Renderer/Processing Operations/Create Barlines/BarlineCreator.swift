import Foundation

// Creates a shared barline that satisfies the barline options of two adjacent
// barlines.
class BarlineCreator {

    func createBarline(leadingOptions: BarlineOptions?, trailingOptions: BarlineOptions?) -> Barline {
        var lineType = Barline.LineType.single
        if trailingOptions?.contains(.double) == true {
            lineType = .double
        }

        let barline = Barline()
        barline.lineType = lineType
        return barline
    }


    /*
    func createBarline(leftOptions: BarlineOptions?, rightOptions: BarlineOptions?) -> Barline {

        switch (leftOptions, rightOptions) {
                // First bar of the composition
            case (nil, let rightOptions?):
                fatalError()
                // Last bar of the composition
            case (let leftOptions?, nil):
                fatalError()
                // A bar in the middle of the composition
            case (let leftOptions?, let rightOptions?):
                return createBarline(leftOptions: leftOptions, rightOptions: rightOptions)
                // Both bars are nil - this should never happen
            case (nil, nil):
                fatalError()
        }
    }

    private func createMiddleBarline(leftOptions: BarlineOptions, rightOptions: BarlineOptions) -> Barline {

        var lineType = Barline.LineType.single

        if rightOptions.contains(.double) {
            lineType = .double
        }

        let barline = Barline()
        barline.lineType = lineType
        return barline
    }
     */
}
