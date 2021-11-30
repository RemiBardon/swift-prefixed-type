//
//  PrefixedStringTests.swift
//  PrefixedTests
//
//  Created by Rémi Bardon on 30/11/2021.
//

import XCTest
@testable import Prefixed

final class PrefixedStringTests: XCTestCase {
	
	/// Generates a random string (in fact it's just a `UUID` without `-`).
	///
	/// - Note: We don't care how it's made, we just want a "random" string.
	static var randomString: String { UUID().uuidString.filter({ $0 != "-" }) }
	
	struct Tag: Hashable, Codable, Identifiable {
		typealias ID = PrefixedString<TagIDPrefix>
		let id: ID
	}
	struct TagIDPrefix: PrefixProtocol {
		static var prefix: String { "tag_" }
	}
	
	struct InsensitiveTag: Hashable, Codable, Identifiable {
		typealias ID = PrefixedString<CaseInsensitiveTagIDPrefix>
		let id: ID
	}
	struct CaseInsensitiveTagIDPrefix: PrefixProtocol {
		static var prefix: String { "lower_tag_" }
		static var isCaseSensitive: Bool { false }
	}
	
	func testDecodeWithInvalidIdPrefix() {
		let data = """
		{"id": "t_67083627"}
		""".data(using: .utf8)!
		
		XCTAssertThrowsError(try JSONDecoder().decode(Tag.self, from: data))
	}
	
	func testDecodeWithValidIdPrefix() {
		let data = """
		{"id": "tag_e338a7f7"}
		""".data(using: .utf8)!
		
		XCTAssertNoThrow(try JSONDecoder().decode(Tag.self, from: data))
	}
	
	func testDecodeWithInvalidIdPrefixCaseInsensitive() {
		let data = """
		{"id": "T_792dee1e"}
		""".data(using: .utf8)!
		
		XCTAssertThrowsError(try JSONDecoder().decode(InsensitiveTag.self, from: data))
	}
	
	func testDecodeWithValidIdPrefixCaseInsensitive() {
		let data = """
		{"id": "lower_TAG_ba995e7f"}
		""".data(using: .utf8)!
		
		XCTAssertNoThrow(try JSONDecoder().decode(InsensitiveTag.self, from: data))
	}
	
	func testEncode() throws {
		let string = Self.randomString
		let tag = Tag(id: PrefixedString(string: string))
		
		let data = try JSONEncoder().encode(tag)
		let result = String(data: data, encoding: .utf8)
		let expected = "{\"id\":\"tag_\(string)\"}"
		
		XCTAssertEqual(result, expected)
	}
	
	func testPrefixedId() {
		let string = Self.randomString
		let id = PrefixedString<TagIDPrefix>(string: string)
		
		let result = id.prefixed
		let expected = "tag_\(string)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testDescription() {
		let string = Self.randomString
		let id = PrefixedString<TagIDPrefix>(string: string)
		
		let result = String(describing: id)
		let expected = "tag_\(string)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testDebugDescription() {
		let string = Self.randomString
		let id = PrefixedString<TagIDPrefix>(string: string)
		
		let result = String(reflecting: id)
		let expected = "(tag_)\(string)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testRawValue() {
		let string = Self.randomString
		let id = PrefixedString<TagIDPrefix>(string: string)
		
		let result = id.rawValue
		let expected = "tag_\(string)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testDecodeFromRawValue() {
		let id = PrefixedString<TagIDPrefix>()
		let result = PrefixedString<TagIDPrefix>(rawValue: id.rawValue)
		
		XCTAssertEqual(result, id)
	}
	
}