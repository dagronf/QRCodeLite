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

// MARK: ASCII generator

struct QRLCodePresentable_ASCII: QRLCodePresentable {
	func generate(
		_ qrcode: QRCode,
		modulePixelSize: Int,
		quietModules: UInt,
		foregroundColor: QRLCode.RGB,
		backgroundColor: QRLCode.RGB?
	) throws -> QRLCode.Result {
		var result = ""
		for row in 0 ..< qrcode.size {
			for col in 0 ..< qrcode.size {
				if qrcode.getModule(x: col, y: row) == true {
					result += "██"
				}
				else {
					result += "  "
				}
			}
			result += "\n"
		}

		guard let data = result.data(using: .utf8) else {
			throw QRLCodeLiteError.cannotConvertStringToData
		}

		return QRLCode.Result(dimension: qrcode.size, data: data)
	}
}

// MARK: Small ASCII generator

internal class QRLCodePresentable_smallASCII: QRLCodePresentable {
	func generate(
		_ qrcode: QRCode,
		modulePixelSize: Int,
		quietModules: UInt,
		foregroundColor: QRLCode.RGB,
		backgroundColor: QRLCode.RGB?
	) throws -> QRLCode.Result {
		var result = ""
		for row in stride(from: 0, to: qrcode.size, by: 2) {
			for col in 0 ..< qrcode.size {
				let top = qrcode.getModule(x: col, y: row)

				if row <= qrcode.size - 2 {
					let bottom = qrcode.getModule(x: col, y: row + 1)
					if top,!bottom { result += "▀" }
					if !top, bottom { result += "▄" }
					if top, bottom { result += "█" }
					if !top, !bottom { result += " " }
				}
				else {
					if top { result += "▀" }
					else { result += " " }
				}
			}
			result += "\n"
		}

		guard let data = result.data(using: .utf8) else {
			throw QRLCodeLiteError.cannotConvertStringToData
		}

		return QRLCode.Result(dimension: qrcode.size / 2, data: data)
	}
}
