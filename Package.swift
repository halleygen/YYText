// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "YYText",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [.library(name: "YYText", targets: ["YYText"])],
    targets: [.target(name: "YYText", path: "Sources")]
)
