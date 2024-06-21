//
//  Copyright © 2024 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import QRCodeGenerator

public struct QRLCode {
	/// Generate a QR Code
	/// - Parameters:
	///   - format: The export format (eg. svg, ppm etc)
	///   - text: The text to encode
	///   - errorCorrection: The error correction level
	///   - modulePixelSize: For image-based exports, the dimension in pixels of each module (square) in the output
	///   - quietModules: The number of quiet modules to include around the outside of the export image
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color, or nil for transparency (if the export format supports it)
	/// - Returns: The generated qr code information
	public static func generate(
		format: QRLCode.ExportType,
		text: String,
		errorCorrection: QRCodeECC = .high,
		modulePixelSize: Int = 3,
		quietModules: UInt = 1,
		foregroundColor: RGB = .black,
		backgroundColor: RGB? = .white
	) throws -> QRLCode.Result {
		try format.generator.generate(
			try QRCode.encode(text: text, ecl: errorCorrection),
			modulePixelSize: modulePixelSize,
			quietModules: quietModules,
			foregroundColor: foregroundColor,
			backgroundColor: backgroundColor
		)
	}

	/// Generate a QR Code image.
	/// - Parameters:
	///   - text: The text to encode
	///   - errorCorrection: The error correction level
	///   - modulePixelSize: For image-based exports, the dimension in pixels of each module (square) in the output
	///   - quietModules: The number of quiet modules to include around the outside of the export image
	///   - foregroundColor: The foreground color
	///   - backgroundColor: The background color, or nil for transparency (if the export format supports it)
	/// - Returns: The raw image pixels
	public static func generatePixels(
		text: String,
		errorCorrection: QRCodeECC = .high,
		modulePixelSize: Int = 3,
		quietModules: UInt = 1,
		foregroundColor: RGB = .black,
		backgroundColor: RGB? = .white
	) throws -> Array2D<QRLCode.RGB> {
		GenerateBitmapArray(
			try QRCode.encode(text: text, ecl: errorCorrection),
			modulePixelSize: modulePixelSize,
			quietModules: quietModules,
			foregroundColor: foregroundColor,
			backgroundColor: backgroundColor
		)
	}

	/// Return the raw QR Code representation
	/// - Parameters:
	///   - text: The text to encode
	///   - errorCorrection: The error correction level
	/// - Returns: A bool matrix containing the raw QR code information
	public static func generateRaw(
		text: String,
		errorCorrection: QRCodeECC = .high
	) throws -> BoolMatrix {
		let qrcode = try QRCode.encode(text: text, ecl: errorCorrection)
		var result = BoolMatrix(dimension: qrcode.size)
		for row in 0 ..< qrcode.size {
			for col in 0 ..< qrcode.size {
				result[row, col] = qrcode.getModule(x: col, y: row)
			}
		}
		return result
	}
}
