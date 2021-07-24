//
//  PrefixedTests.swift
//  PrefixedTests
//
//  Created by Rémi Bardon on 24/07/2021.
//

import XCTest
@testable import Prefixed

final class PrefixedTests: XCTestCase {
	
	struct User: Hashable, Codable, Identifiable {
		typealias ID = Prefixed<UserIDPrefix, Int>
		let id: ID
	}
	struct UserIDPrefix: PrefixProtocol {
		static var prefix: String { "user_" }
	}
	
	struct InsensitiveUser: Hashable, Codable, Identifiable {
		typealias ID = Prefixed<CaseInsensitiveUserIDPrefix, Int>
		let id: ID
	}
	struct CaseInsensitiveUserIDPrefix: PrefixProtocol {
		static var prefix: String { "lower_user_" }
		static var isCaseSensitive: Bool { false }
	}
	
	struct LikedPrefix: PrefixProtocol {
		static var prefix: String { "liked_" }
	}
	
	func testDecodeWithInvalidIdPrefix() {
		let data = """
		{"id": "u_834"}
		""".data(using: .utf8)!
		
		XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: data))
	}
	
	func testDecodeWithInvalidID() {
		let data = """
		{"id": "user_abc"}
		""".data(using: .utf8)!
		
		XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: data))
	}
	
	func testDecodeWithValidIdPrefix() {
		let data = """
		{"id": "user_65"}
		""".data(using: .utf8)!
		
		XCTAssertNoThrow(try JSONDecoder().decode(User.self, from: data))
	}
	
	func testDecodeWithInvalidIdPrefixCaseInsensitive() {
		let data = """
		{"id": "U_8253"}
		""".data(using: .utf8)!
		
		XCTAssertThrowsError(try JSONDecoder().decode(InsensitiveUser.self, from: data))
	}
	
	func testDecodeWithValidIdPrefixCaseInsensitive() {
		let data = """
		{"id": "lower_USER_784359"}
		""".data(using: .utf8)!
		
		XCTAssertNoThrow(try JSONDecoder().decode(InsensitiveUser.self, from: data))
	}
	
	func testEncode() throws {
		let int = Int.random(in: 0...9999)
		let user = User(id: Prefixed(base: int))
		
		let data = try JSONEncoder().encode(user)
		let result = String(data: data, encoding: .utf8)
		let expected = "{\"id\":\"user_\(int)\"}"
		
		XCTAssertEqual(result, expected)
	}
	
	func testPrefixedId() {
		let int = Int.random(in: 0...9999)
		let id = Prefixed<UserIDPrefix, Int>(base: int)
		
		let result = id.prefixed
		let expected = "user_\(int)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testDescription() {
		let int = Int.random(in: 0...9999)
		let id = Prefixed<UserIDPrefix, Int>(base: int)
		
		let result = String(describing: id)
		let expected = "user_\(int)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testDebugDescription() {
		let int = Int.random(in: 0...9999)
		let id = Prefixed<UserIDPrefix, Int>(base: int)
		
		let result = String(reflecting: id)
		let expected = "(user_)\(int)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testRawValue() {
		let int = Int.random(in: 0...9999)
		let id = Prefixed<UserIDPrefix, Int>(base: int)
		
		let result = id.rawValue
		let expected = "user_\(int)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testDecodeFromRawValue() {
		let int = Int.random(in: 0...9999)
		let id = Prefixed<UserIDPrefix, Int>(base: int)
		let result = Prefixed<UserIDPrefix, Int>(rawValue: id.rawValue)
		
		XCTAssertEqual(result, id)
	}
	
	func testDecodePrefixedBooleanFromRawValue() {
		let bool = true
		let id = Prefixed<LikedPrefix, Bool>(base: bool)
		let result = Prefixed<LikedPrefix, Bool>(rawValue: id.rawValue)
		
		XCTAssertEqual(result, id)
	}
	
}

