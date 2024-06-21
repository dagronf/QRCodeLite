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

/// A boolean matrix (Array2D<Bool> wrapper) with equal dimensions in row and column
public struct BoolMatrix {
	/// Create a boolean matrix with a dimension with a false initial state
	/// - Parameter dimension: The dimension for the matrix
	public init(dimension: Int) {
		self.content = Array2D(
			rows: dimension,
			columns: dimension,
			initialValue: false)
	}

	/// Create a boolean matrix with a dimension
	/// - Parameters:
	///   - dimension: The dimension for the matrix
	///   - flattened: A 1-d array of Bool defining the initial state of the matrix
	public init(dimension: Int, flattened: [Bool]) {
		self.content = Array2D(
			rows: dimension,
			columns: dimension,
			flattened: flattened)
	}

	/// Create a boolean matrix with a dimension
	/// - Parameters:
	///   - dimension: The dimension for the matrix
	///   - flattened: A 1-d array of Int defining the initial state of the matrix
	///
	/// A simple initializer to use [0, 1, 1, 0, 1, 0, 0, 0, 0, 1] as the bool initializer
	public init(dimension: Int, rawFlattenedInt: [Int]) {
		let settings = rawFlattenedInt.map { $0 != 0 }
		self.content = Array2D(
			rows: dimension,
			columns: dimension,
			flattened: settings
		)
	}

	/// The dimension of the QR code
	public var dimension: Int {
		return content.rows
	}

	/// Return a flattened version of the bool matrix
	public var flattened: [Bool] {
		content.flattened
	}

	/// Returns a new matrix with toggled values
	public var flipped: BoolMatrix {
		BoolMatrix(dimension: content.columns, flattened: flattened.map { !$0 })
	}

	/// get/set the value at the row/column position. Does not check for out of bounds (that's your responsibility!)
	public subscript(row: Int, column: Int) -> Bool {
		get {
			return content[row, column]
		}
		set {
			content[row, column] = newValue
		}
	}

	public var description: String {
		var str = ""
		for y in 0 ..< dimension {
			for x in 0 ..< dimension {
				str.append(self[y, x] ? "#" : ".")
			}
			str.append("\n")
		}
		return str
	}

	private var content: Array2D<Bool> = Array2D(rows: 0, columns: 0, initialValue: false)
}
