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

// Generate a 2D RGB array representation for the qrcode
internal func GenerateBitmapArray(
	_ qrcode: QRCode,
	modulePixelSize: Int,
	quietModules: UInt = 1,
	foregroundColor: QRLCode.RGB = .black,
	backgroundColor: QRLCode.RGB? = .white
) -> Array2D<QRLCode.RGB> {
	let dimension = modulePixelSize * qrcode.size + (2 * Int(quietModules) * modulePixelSize)
	var result = Array2D(rows: dimension, columns: dimension, initialValue: backgroundColor ?? .white)
	let offset = Int(quietModules) * modulePixelSize
	for row in 0 ..< qrcode.size {
		for col in 0 ..< qrcode.size {
			if qrcode.getModule(x: col, y: row) == true {
				let minX = offset + (modulePixelSize * col)
				let minY = offset + (modulePixelSize * row)

				(0 ..< modulePixelSize).forEach { y in
					(0 ..< modulePixelSize).forEach { x in
						let x = min(dimension - 1, minX + x)
						let y = min(dimension - 1, minY + y)
						result[y, x] = foregroundColor
					}
				}
			}
		}
	}
	return result
}
