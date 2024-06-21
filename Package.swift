// swift-tools-version: 5.4

import PackageDescription

let package = Package(
	name: "QRCodeLite",
	products: [
		.library(
			name: "QRCodeLite",
			targets: ["QRCodeLite"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/dagronf/swift-qrcode-generator", .upToNextMinor(from: "2.0.2")),
		.package(url: "https://github.com/dagronf/BytesParser", .upToNextMinor(from: "1.0.0")),
	],
	targets: [
		.target(
			name: "QRCodeLite",
			dependencies: [
				.product(name: "QRCodeGenerator", package: "swift-qrcode-generator"),
				"BytesParser",
			],
			resources: [
				.copy("PrivacyInfo.xcprivacy"),
			]
		),

		.testTarget(
			name: "QRCodeLiteTests",
			dependencies: ["QRCodeLite"],
			resources: [
				.process("resources"),
			]
		),
	]
)
