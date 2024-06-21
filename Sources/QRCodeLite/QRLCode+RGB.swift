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

public extension QRLCode {
	/// An RGB color
	struct RGB {
		/// Red component (0 ... 255)
		public let r255: UInt8
		/// Green component (0 ... 255)
		public let g255: UInt8
		/// Blue component (0 ... 255)
		public let b255: UInt8
		/// Alpha component (0.0 ... 1.0)
		public let alpha: Double

		/// Alpha component (0 ... 255)
		public var a255: UInt8 { UInt8(alpha * 255.0) }

		/// Create an RGB color
		/// - Parameters:
		///   - r255: Red component (0 ... 255)
		///   - g255: Green component (0 ... 255)
		///   - b255: Blue component (0 ... 255)
		@inlinable public static func rgb(_ r255: UInt8, _ g255: UInt8, _ b255: UInt8) -> RGB {
			RGB(r255: r255, g255: g255, b255: b255)
		}

		/// Create an RGBA color
		/// - Parameters:
		///   - r255: Red component (0 ... 255)
		///   - g255: Green component (0 ... 255)
		///   - b255: Blue component (0 ... 255)
		///   - a255: Alpha component (0.0 ... 1.0)
		@inlinable public static func rgba(_ r255: UInt8, _ g255: UInt8, _ b255: UInt8, alpha: Double) -> RGB {
			RGB(r255: r255, g255: g255, b255: b255, alpha: alpha)
		}

		/// Create an RGB color
		/// - Parameters:
		///   - r255: Red component (0 ... 255)
		///   - g255: Green component (0 ... 255)
		///   - b255: Blue component (0 ... 255)
		public init(r255: UInt8, g255: UInt8, b255: UInt8, alpha: Double = 1.0) {
			self.r255 = r255
			self.g255 = g255
			self.b255 = b255
			self.alpha = alpha.unitClamped()
		}

		/// Create an RGB color
		/// - Parameters:
		///   - rf: Red component (0.0 ... 1.0)
		///   - gf: Green component (0.0 ... 1.0)
		///   - bf: Blue component (0.0 ... 1.0)
		///   - af: Alpha component (0.0 ... 1.0)
		public init(rf: Double, gf: Double, bf: Double, af: Double = 1.0) {
			self.r255 = UInt8(rf.unitClamped() * 255.0)
			self.g255 = UInt8(gf.unitClamped() * 255.0)
			self.b255 = UInt8(bf.unitClamped() * 255.0)
			self.alpha = af.unitClamped()
		}

		/// Return a version of this color with the specified alpha component
		/// - Parameter alpha: The alpha value (0.0 ... 1.0)
		/// - Returns: A new color
		public func withAlpha(_ alpha: Double) -> QRLCode.RGB {
			QRLCode.RGB(r255: self.r255, g255: self.g255, b255: self.b255, alpha: alpha)
		}

		/// The hex RGB string descriptor for the color (eg. "#E511AA")
		var hexRGB: String { String(format: "#%02X%02X%02X", r255, g255, b255) }
		/// The hex RGBA string descriptor including alpha for the color (eg. "#E511AAFF")
		var hexRGBA: String { String(format: "#%02X%02X%02X%02X", r255, g255, b255, a255) }

		/// A string containing an rgb string representation (eg. "rgba(0,255,10)")
		var rgb255: String { "rgb(\(r255),\(g255),\(b255))" }
		/// A string containing an rgba string representation (eg. "rgba(0,255,10,0.4)")
		var rgba255: String { "rgba(\(r255),\(g255),\(b255),\(alpha))" }
	}
}

extension QRLCode.RGB {
	/// White color
	public static let white   = QRLCode.RGB(r255: 255, g255: 255, b255: 255)
	/// Black color
	public static let black   = QRLCode.RGB(r255: 0, g255: 0, b255: 0)

	/// Red color
	public static let red     = QRLCode.RGB(r255: 255, g255: 0, b255: 0)
	/// Green color
	public static let green   = QRLCode.RGB(r255: 0, g255: 255, b255: 0)
	/// Blue color
	public static let blue    = QRLCode.RGB(r255: 0, g255: 0, b255: 255)

	/// Cyan
	public static let cyan    = QRLCode.RGB(r255: 0, g255: 255, b255: 255)
	/// Yellow
	public static let yellow  = QRLCode.RGB(r255: 255, g255: 255, b255: 0)
	/// Magenta
	public static let magenta = QRLCode.RGB(r255: 255, g255: 0, b255: 255)
}
