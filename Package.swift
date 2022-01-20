// swift-tools-version:5.3
import PackageDescription

let package = Package(name: "MusicNotationKit",
                      platforms: [.iOS(.v14)],
                      products: [.library(name: "MusicNotationKit",
                                          targets: ["MusicNotationKit"])],
                      targets: [.target(name: "MusicNotationKit",
                                        path: "MusicNotationKit/MusicNotationKit"),
                                .testTarget(name: "MusicNotationKitTests",
                                            dependencies: ["MusicNotationKit"],
                                            path: "MusicNotationKit/MusicNotationKitTests")],
                      swiftLanguageVersions: [.v5])
