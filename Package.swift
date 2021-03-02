// swift-tools-version:5.3
import PackageDescription

let package = Package(name: "MirrorUI",
                      platforms: [.macOS(.v11),
                                  .iOS(.v14),
                                  .tvOS(.v14)],
                      products: [.library(name: "MirrorUI",
                                          targets: ["MirrorUI"])],
                      targets: [.target(name: "MirrorUI",
                                        path: "MirrorUI/MirrorUI"),
                                .testTarget(name: "MirrorUITests",
                                            dependencies: ["MirrorUI"],
                                            path: "MirrorUI/MirrorUITests")],
                      swiftLanguageVersions: [.v5])
