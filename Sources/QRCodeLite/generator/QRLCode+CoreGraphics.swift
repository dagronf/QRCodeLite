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

#if canImport(CoreGraphics)

import Foundation
import CoreGraphics
import ImageIO
import QRCodeGenerator

internal func generateCoreGraphics(
	_ qrcode: QRCode,
	modulePixelSize: Int,
	quietModules: UInt = 1,
	foregroundColor: QRLCode.RGB = .black,
	backgroundColor: QRLCode.RGB? = .white
) throws -> CGImage {
	// Generate the raw pixel information
	let result = GenerateBitmapArray(
		qrcode,
		modulePixelSize: modulePixelSize,
		quietModules: quietModules,
		foregroundColor: foregroundColor,
		backgroundColor: backgroundColor
	)

	var rgbaBytes: [UInt8] = result.flattened.flatMap { [$0.r255, $0.g255, $0.b255, $0.a255] }
	guard
		let ctx = CGContext(
			data: &rgbaBytes,
			width: result.rows,
			height: result.columns,
			bitsPerComponent: 8,
			bytesPerRow: result.columns * 4,
			space: CGColorSpace(name: CGColorSpace.sRGB)!,
			bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
		)
	else {
		throw QRLCodeLiteError.cannotGenerateBitmap
	}

	guard let image = ctx.makeImage() else {
		throw QRLCodeLiteError.cannotGenerateBitmap
	}

	return image
}

func generatePNG(_ image: CGImage) throws -> Data {
	guard
		let mutableData = CFDataCreateMutable(nil, 0),
		let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil)
	else {
		throw QRLCodeLiteError.cannotGenerateBitmap
	}

	CGImageDestinationAddImage(destination, image, nil)
	guard CGImageDestinationFinalize(destination) else {
		throw QRLCodeLiteError.cannotGenerateBitmap
	}

	return Data(mutableData as Data)
}

func generateBMP(_ image: CGImage) throws -> Data {
	guard
		let mutableData = CFDataCreateMutable(nil, 0),
		let destination = CGImageDestinationCreateWithData(mutableData, "com.microsoft.bmp" as CFString, 1, nil)
	else {
		throw QRLCodeLiteError.cannotGenerateBitmap
	}

	CGImageDestinationAddImage(destination, image, nil)
	guard CGImageDestinationFinalize(destination) else {
		throw QRLCodeLiteError.cannotGenerateBitmap
	}

	return Data(mutableData as Data)
}

#endif
