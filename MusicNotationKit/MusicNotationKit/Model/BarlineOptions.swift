import Foundation

// The barline options that a bar requires. This is used to construct a barline
// object that satisfies all of the options of two adjacent bars.
public struct BarlineOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let double = BarlineOptions(rawValue: 1 << 0)
    public static let final = BarlineOptions(rawValue: 1 << 1)
    public static let startRepeat = BarlineOptions(rawValue: 1 << 2)
    public static let endRepeat = BarlineOptions(rawValue: 1 << 3)
}
