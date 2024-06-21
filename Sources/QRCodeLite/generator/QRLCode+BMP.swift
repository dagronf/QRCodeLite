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

struct QRLCodePresentable_BMP: QRLCodePresentable {
	func generate(
		_ qrcode: QRCode,
		modulePixelSize: Int,
		quietModules: UInt = 1,
		foregroundColor: QRLCode.RGB = .black,
		backgroundColor: QRLCode.RGB? = .white
	) throws -> QRLCode.Result {
		let result = GenerateBitmapArray(
			qrcode,
			modulePixelSize: modulePixelSize,
			quietModules: quietModules,
			foregroundColor: foregroundColor,
			backgroundColor: backgroundColor
		)

		let flipped = result.flipVertical().flattened
		let dimension = result.rows
		let data = try BMP.write(pixels: flipped, width: dimension, height: dimension)
		return QRLCode.Result(dimension: dimension, data: data)
	}
}
