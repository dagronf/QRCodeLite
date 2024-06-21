//
//  QRCodeLite.swift
//
//
//  Created by Darren Ford on 19/6/2024.
//

import XCTest
@testable import QRCodeLite

internal let testResultsContainer = try! TestFilesContainer(named: "QRCodeLiteTests")

let outputFolder = testResultsContainer.root

func generate(
	folder: TestFilesContainer.Subfolder,
	filename: String,
	text: String,
	modulePixelSize: Int,
	quietModules: UInt = 1,
	foregroundColor: QRLCode.RGB = .black,
	backgroundColor: QRLCode.RGB? = .white
) throws {
	try [
		QRLCode.ExportType.ppm,
		QRLCode.ExportType.bmp,
		QRLCode.ExportType.svg
	].forEach { type in
		let qrcode = try QRLCode.generate(
			format: type,
			text: text,
			modulePixelSize: modulePixelSize,
			quietModules: quietModules,
			foregroundColor: foregroundColor,
			backgroundColor: backgroundColor
		)

		try folder.write(qrcode.data, to: "\(filename).\(type.fileExtension)")
	}
}

final class QRCodeLiteTests: XCTestCase {

	func testDoco() throws {
		let outputFolder = try outputFolder.subfolder(with: "documentation")
		try generate(
			folder: outputFolder,
			filename: "documentation-1",
			text: "My QR Code!!",
			modulePixelSize: 8
		)

		try generate(
			folder: outputFolder,
			filename: "documentation-2",
			text: "This is a test",
			modulePixelSize: 4,
			foregroundColor: .rgb(0, 100, 0),
			backgroundColor: .yellow
		)
	}

	func testBMP() throws {
		let outputFolder = try outputFolder.subfolder(with: "testBMP")
		do {
			let data1 = try QRLCode.generate(
				format: .bmp,
				text: "This is a test",
				modulePixelSize: 4,
				quietModules: 0
			)
			Swift.print(data1)
		}

		do {
			let data1 = try QRLCode.generate(
				format: .bmp,
				text: "This is a test",
				modulePixelSize: 6,
				quietModules: 2,
				foregroundColor: .blue,
				backgroundColor: .rgb(0, 0, 50)
			)
			try outputFolder.write(data1.data, to: "bmptest-1.bmp")
			let e1 = try resourceData(for: "bmptest-1-orig", extension: "bmp")
			XCTAssertEqual(e1, data1.data)
		}

		do {
			let data1 = try QRLCode.generate(
				format: .bmp,
				text: "This is a test",
				modulePixelSize: 6,
				quietModules: 2,
				foregroundColor: .blue,
				backgroundColor: nil
			)

			try outputFolder.write(data1.data, to: "bmptest-2.bmp")
			let e1 = try resourceData(for: "bmptest-2-orig", extension: "bmp")
			XCTAssertEqual(e1, data1.data)
		}

		do {
			let data1 = try QRLCode.generate(
				format: .bmp,
				text: "This is a test",
				modulePixelSize: 3,
				quietModules: 0,
				foregroundColor: .blue,
				backgroundColor: .yellow.withAlpha(0.2)
			)

			try outputFolder.write(data1.data, to: "bmptest-3.bmp")
			let e1 = try resourceData(for: "bmptest-3-orig", extension: "bmp")
			XCTAssertEqual(e1, data1.data)
		}
	}

	func testSVG() throws {
		let outputFolder = try outputFolder.subfolder(with: "testSVG")
		let data1 = try QRLCode.generate(
			format: .svg,
			text: "This is a test",
			modulePixelSize: 8,
			foregroundColor: .rgb(0, 100, 0)
		)
		try outputFolder.write(data1.data, to: "svgtest-1.svg")
		let e1 = try resourceData(for: "svgtest-1-orig", extension: "svg")
		XCTAssertEqual(e1, data1.data)

		let data2 = try QRLCode.generate(
			format: .svg,
			text: "This is a test",
			modulePixelSize: 8,
			quietModules: 4,
			foregroundColor: .rgb(0, 100, 0),
			backgroundColor: .rgba(0, 100, 0, alpha: 0.2)
		)
		
		try outputFolder.write(data2.data, to: "svgtest-2.svg")
		let e2 = try resourceData(for: "svgtest-2-orig", extension: "svg")
		XCTAssertEqual(e2, data2.data)
	}

	func testBasicPPM() throws {
		let outputFolder = try outputFolder.subfolder(with: "testBasicPPM")

		do {
			let data1 = try QRLCode.generate(format: .ppm, text: "This is a test", modulePixelSize: 3)
			try outputFolder.write(data1.data, to: "ppm-1.ppm")
			let e1 = try resourceData(for: "ppm-1-orig", extension: "ppm")
			XCTAssertEqual(e1, data1.data)
		}

		do {
			let data2 = try QRLCode.generate(
				format: .ppm,
				text: "This is a test",
				modulePixelSize: 3,
				quietModules: 5,
				foregroundColor: .rgb(0, 100, 0)
			)
			try outputFolder.write(data2.data, to: "ppm-2.ppm")

			let e2 = try resourceData(for: "ppm-2-orig", extension: "ppm")
			XCTAssertEqual(e2, data2.data)
		}

		do {
			let data3 = try QRLCode.generate(
				format: .ppm,
				text: "This is a test",
				modulePixelSize: 3,
				quietModules: 0,
				foregroundColor: .red,
				backgroundColor: .blue
			)

			try outputFolder.write(data3.data, to: "ppm-3.ppm")
			let e3 = try resourceData(for: "ppm-3-orig", extension: "ppm")
			XCTAssertEqual(e3, data3.data)
		}
	}

	func testBasicAscii() throws {
		let outputFolder = try outputFolder.subfolder(with: "testBasicAscii")
		do {
			let data1 = try QRLCode.generate(format: .ascii, text: "This is a test")
			try outputFolder.write(data1.data, to: "output-regular.txt")
			let e1 = try resourceData(for: "output-regular", extension: "txt")
			XCTAssertEqual(e1, data1.data)
		}

		do {
			let data2 = try QRLCode.generate(format: .smallAscii, text: "This is a test")
			try outputFolder.write(data2.data, to: "output-small.txt")
			let e2 = try resourceData(for: "output-small", extension: "txt")
			XCTAssertEqual(e2, data2.data)
		}
	}

	func testRawExport1() throws {
		let expected = """
#######..#....#######
#.....#.#.###.#.....#
#.###.#.###.#.#.###.#
#.###.#.##....#.###.#
#.###.#.##.#..#.###.#
#.....#.###...#.....#
#######.#.#.#.#######
............#........
..#..####..###.#####.
.##.##.#..##..##.###.
#...###.#.#.#.####.##
##.#.#..##..#..#.###.
#.##..#.#.....#######
........##..#.#......
#######.####.#....#..
#.....#.##.###..#...#
#.###.#..###.##...#..
#.###.#..###...#.##..
#.###.#.##.##..###.##
#.....#.....#.##.##..
#######...#.#..######

"""

		let raw1 = try QRLCode.generateRaw(text: "", errorCorrection: .low)
		//Swift.print(raw1.description)
		XCTAssertEqual(expected, raw1.description)
	}
	
	func testRawExport2() throws {
		let expected = """
#######...##..###.#######
#.....#.#.###..##.#.....#
#.###.#...#....##.#.###.#
#.###.#..###...##.#.###.#
#.###.#..#.###..#.#.###.#
#.....#.#...#..##.#.....#
#######.#.#.#.#.#.#######
........#................
....####.#..#..##.##...#.
#.##...###.......#..###..
....######.#.##.##.#..#..
.##.##.#####.#.##.##..#..
#..#.##.###.##...###.##..
#.##.#.##.##..#.##..#....
...#..##...#.#..#....##..
...##...#######..#.#..#.#
###.###.###....######.#.#
........##.##.###...####.
#######.#.####.##.#.###..
#.....#.####.####...#.#.#
#.###.#.#.##..#.#####.#..
#.###.#...#....#..#..#..#
#.###.#...#.##.###.#..##.
#.....#..####.###.#..###.
#######..#.#.#.##..##.###

"""

		let raw1 = try QRLCode.generateRaw(text: "simple test", errorCorrection: .high)
		//Swift.print(raw1.description)
		XCTAssertEqual(expected, raw1.description)
	}
}
