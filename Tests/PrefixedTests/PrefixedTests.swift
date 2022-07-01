//
//  PrefixedTests.swift
//  PrefixedTests
//
//  Created by Rémi Bardon on 24/07/2021.
//

@testable import Prefixed
import XCTest

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

	static var randomInt: Int { Int.random(in: 0...9999) }

	func testDecodeWithInvalidIdPrefix() throws {
		let data = try XCTUnwrap("""
		{"id": "u_834"}
		""".data(using: .utf8))

		XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: data))
	}

	func testDecodeWithInvalidID() throws {
		let data = try XCTUnwrap("""
		{"id": "user_abc"}
		""".data(using: .utf8))

		XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: data))
	}

	func testDecodeWithValidIdPrefix() throws {
		let data = try XCTUnwrap("""
		{"id": "user_65"}
		""".data(using: .utf8))

		XCTAssertNoThrow(try JSONDecoder().decode(User.self, from: data))
	}

	func testDecodeWithInvalidIdPrefixCaseInsensitive() throws {
		let data = try XCTUnwrap("""
		{"id": "U_8253"}
		""".data(using: .utf8))

		XCTAssertThrowsError(try JSONDecoder().decode(InsensitiveUser.self, from: data))
	}

	func testDecodeWithValidIdPrefixCaseInsensitive() throws {
		let data = try XCTUnwrap("""
		{"id": "lower_USER_784359"}
		""".data(using: .utf8))

		XCTAssertNoThrow(try JSONDecoder().decode(InsensitiveUser.self, from: data))
	}

	func testDecodeWithInvalidTypeUUID() throws {
		let data = try XCTUnwrap("""
		{"id": "user_ABCD"}
		""".data(using: .utf8))

		XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: data))
	}

	func testEncode() throws {
		let int = Self.randomInt
		let user = User(id: Prefixed(base: int))

		let data = try JSONEncoder().encode(user)
		let result = String(data: data, encoding: .utf8)
		let expected = "{\"id\":\"user_\(int)\"}"

		XCTAssertEqual(result, expected)
	}

	func testPrefixedId() {
		let int = Self.randomInt
		let id = User.ID(base: int)

		let result = id.prefixed
		let expected = "user_\(int)"

		XCTAssertEqual(result, expected)
	}

	func testDescription() {
		let int = Self.randomInt
		let id = User.ID(base: int)

		let result = String(describing: id)
		let expected = "user_\(int)"

		XCTAssertEqual(result, expected)
	}

	func testDebugDescription() {
		let int = Self.randomInt
		let id = User.ID(base: int)

		let result = String(reflecting: id)
		let expected = "(user_)\(int)"

		XCTAssertEqual(result, expected)
	}

	func testRawValue() {
		let int = Self.randomInt
		let id = User.ID(base: int)

		let result = id.rawValue
		let expected = "user_\(int)"

		XCTAssertEqual(result, expected)
	}

	func testDecodeFromRawValue() {
		let int = Self.randomInt
		let id = Prefixed<UserIDPrefix, Int>(base: int)
		let result = Prefixed<UserIDPrefix, Int>(rawValue: id.rawValue)

		XCTAssertEqual(result, id)
	}

	func testDecodePrefixedBooleanFromRawValue() {
		let bool = Bool.random()
		let id = Prefixed<LikedPrefix, Bool>(base: bool)
		let result = Prefixed<LikedPrefix, Bool>(rawValue: id.rawValue)

		XCTAssertEqual(result, id)
	}
}
