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

internal class QRLCodePresentable_SVG: QRLCodePresentable {
	func generate(
		_ qrcode: QRCode,
		modulePixelSize: Int,
		quietModules: UInt = 1,
		foregroundColor: QRLCode.RGB = .black,
		backgroundColor: QRLCode.RGB? = .white
	) throws -> QRLCode.Result {
		assert(modulePixelSize >= 0)

		// The SVG dimension (in pixels)
		let dimension = (modulePixelSize * qrcode.size) + (2 * modulePixelSize * Int(quietModules))

		// The module size (in pixels)
		let mps = Double(dimension) / Double(qrcode.size + (2 * Int(quietModules)))

		var svg = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" version=\"1.1\" height=\"\(dimension)\" width=\"\(dimension)\">\n"

		// Add the background if requested
		if let bc = backgroundColor {
			svg += "   <rect id='background' x='0' y='0' width='\(dimension)' height='\(dimension)' fill='\(bc.rgba255)' />\n"
		}

		// Add in an amount so we don't have blank lines between the modules
		let mss = self._SVGF(mps + 0.2)

		let offset = Double(quietModules) * mps

		// Add the forground modules
		svg += "   <g id='foreground'>\n"
		for row in 0 ..< qrcode.size {
			for col in 0 ..< qrcode.size {
				if qrcode.getModule(x: col, y: row) == true {
					let minX = offset + (mps * Double(col))
					let minY = offset + (mps * Double(row))

					svg += "      <rect x='\(self._SVGF(minX))' y='\(self._SVGF(minY))' width='\(mss)' height='\(mss)' fill='\(foregroundColor.rgba255)' />\n"
				}
			}
		}

		svg += "   </g>\n"
		svg += "</svg>\n"

		guard let data = svg.data(using: .utf8) else {
			throw QRLCodeLiteError.cannotConvertStringToData
		}

		return QRLCode.Result(dimension: dimension, data: data)
	}

	// private

	private let formatter: NumberFormatter = {
		let f = NumberFormatter()
		f.minimumFractionDigits = 0
		f.maximumFractionDigits = 3
		f.decimalSeparator = "."
		return f
	}()

	// Format a float value as a string in an SVG savvy-way
	private func _SVGF<T: BinaryFloatingPoint>(_ value: T) -> String {
		self.formatter.string(for: NSNumber(value: Double(value)))!
	}
}
