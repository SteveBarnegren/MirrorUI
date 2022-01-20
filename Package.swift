// swift-tools-version:5.3
import PackageDescription

let package = Package(name: "MusicNotationKit",
                      platforms: [.iOS(.v14)],
                      products: [.library(name: "MusicNotationKit",
                                          targets: ["MusicNotationKit"])],
                      targets: [.target(name: "MusicNotationKit",
                                        path: "MusicNotationKit/MusicNotationKit",
                                        exclude: ["Info.plist"],
                                        resources: [
                                            .copy("Font/Bravura/bravura_metadata.json"),
                                            .copy("Font/Bravura/Bravura.otf"),
                                            .copy("Font/SmuFL/classes.json"),
                                            .copy("Font/SmuFL/glyphnames.json"),
                                            .copy("Font/SmuFL/ranges.json")
                                        ]),
                                .testTarget(name: "MusicNotationKitTests",
                                            dependencies: ["MusicNotationKit"],
                                            path: "MusicNotationKit/MusicNotationKitTests",
                                            exclude: ["Info.plist"])],
                      swiftLanguageVersions: [.v5])
