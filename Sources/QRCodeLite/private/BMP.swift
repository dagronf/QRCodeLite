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
import BytesParser

// Very simple BMP writer routines

internal struct BMP {
	static func write(pixels: [QRLCode.RGB], width: Int, height: Int) throws -> Data {
		let pixelCount = UInt32(width * height)
		assert(pixels.count == pixelCount)
		return try BytesWriter.build { writer in

			let sizeOfBitmapFile: UInt32 = 54 + pixelCount

			// bmp header
			try writer.writeStringASCII("BM")
			try writer.writeUInt32(sizeOfBitmapFile, .little)
			try writer.writeUInt32(0, .little)
			try writer.writeUInt32(54, .little)

			// bmpinfo header
			try writer.writeUInt32(40, .little)            // size of header
			try writer.writeInt32(Int32(width), .little)   // in pixels
			try writer.writeInt32(Int32(height), .little)  // in pixels
			try writer.writeInt16(1, .little)              // number of color planes (1)
			try writer.writeInt16(32, .little)             // color depth
			try writer.writeUInt32(0, .little)             // compression method
			try writer.writeUInt32(0, .little)             // rawBitmapDataSize (ignored?)
			try writer.writeInt32(3780, .little)           // horizontal resolution in pixels per meter
			try writer.writeInt32(3780, .little)           // vertical resolution in pixels per meter
			try writer.writeUInt32(0, .little)             // color table entries
			try writer.writeUInt32(0, .little)             // important colors

			try pixels.forEach { pixel in
				try writer.writeByte(pixel.b255)
				try writer.writeByte(pixel.g255)
				try writer.writeByte(pixel.r255)
				try writer.writeByte(pixel.a255)
			}
		}
	}
}
