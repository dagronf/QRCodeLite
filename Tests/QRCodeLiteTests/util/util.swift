//
//  File.swift
//  
//
//  Created by Darren Ford on 21/6/2024.
//

import Foundation
import XCTest
@testable import QRCodeLite

enum TestErrors: Error {
	case invalidURL
	case invalidImage
}

func resourceURL(for resource: String, extension extn: String) throws -> URL {
	guard let url = Bundle.module.url(forResource: resource, withExtension: extn) else {
		throw TestErrors.invalidURL
	}
	return url
}

func resourceData(for resource: String, extension extn: String) throws -> Data {
	let url = try resourceURL(for: resource, extension: extn)
	return try Data(contentsOf: url)
}


