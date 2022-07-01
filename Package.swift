// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "prefixed",
	platforms: [
		.macOS(.v10_13),
		.iOS(.v11),
	],
	products: [
		.library(name: "Prefixed", targets: ["Prefixed"]),
	],
	targets: [
		.target(name: "Prefixed"),
		.testTarget(name: "PrefixedTests", dependencies: ["Prefixed"]),
	]
)
