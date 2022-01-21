extension Bundle {
    static var framework: Bundle {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle(for: SMuFLSupport.self)
#endif
    }
}
