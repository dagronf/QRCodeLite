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

extension QRLCode {
	/// Supported export formats
	public enum ExportType {
		/// PPM (bitmap)
		case ppm
		/// Microsoft Bitmap format
		case bmp
		/// SVG (vector)
		case svg
		/// Ascii
		case ascii
		/// Small ascii
		case smallAscii

		/// File extension for the export format
		public var fileExtension: String {
			switch self {
			case .ppm: return "ppm"
			case .bmp: return "bmp"
			case .svg: return "svg"
			case .ascii: return "txt"
			case .smallAscii: return "txt"
			}
		}
	}
}

extension QRLCode.ExportType {
	internal var generator: QRLCodePresentable {
		switch self {
		case .ppm:
			return QRLCodePresentable_PPM()
		case .bmp:
			return QRLCodePresentable_BMP()
		case .svg:
			return QRLCodePresentable_SVG()
		case .ascii:
			return QRLCodePresentable_ASCII()
		case .smallAscii:
			return QRLCodePresentable_smallASCII()
		}
	}
}
