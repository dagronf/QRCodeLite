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

struct QRLCodePresentable_PPM: QRLCodePresentable {
	func generate(
		_ qrcode: QRCode,
		modulePixelSize: Int,
		quietModules: UInt = 1,
		foregroundColor: QRLCode.RGB = .black,
		backgroundColor: QRLCode.RGB? = .white
	) throws -> QRLCode.Result {

		// Generate the raw pixel information
		let result = GenerateBitmapArray(
			qrcode,
			modulePixelSize: modulePixelSize,
			quietModules: quietModules,
			foregroundColor: foregroundColor,
			backgroundColor: backgroundColor
		)
		let dimension = result.rows

		var data = Data()
		data.append("P6\n".data(using: .utf8)!)
		data.append("# QRLCode Generated\n".data(using: .utf8)!)
		data.append("\(dimension) \(dimension)\n255\n".data(using: .utf8)!)
		for pix in result.flattened {
			data.append(contentsOf: [pix.r255, pix.g255, pix.b255])
		}
		return QRLCode.Result(dimension: dimension, data: data)
	}
}
