// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftHttp",
	platforms: [
		.macOS(.v10_18),
		.iOS(.v15)
	],
	products: [
	// Products define the executables and libraries a package produces, and make them visible to other packages.
	.library( name: "SwiftHttp", targets: ["SwiftHttp"]),
	],
	dependencies: [],
	targets: [
		.target(name: "SwiftHttp" ),
		.testTarget( name: "SwiftHttpTests", dependencies: ["SwiftHttp"]),
	]
)
