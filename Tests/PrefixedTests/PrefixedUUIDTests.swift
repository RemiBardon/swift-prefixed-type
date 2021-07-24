//
//  PrefixedUUIDTests.swift
//  PrefixedTests
//
//  Created by Rémi Bardon on 29/06/2021.
//

import XCTest
@testable import Prefixed

final class PrefixedUUIDTests: XCTestCase {
	
	struct User: Hashable, Codable, Identifiable {
		typealias ID = PrefixedUUID<UserIDPrefix>
		let id: ID
	}
	struct UserIDPrefix: PrefixProtocol {
		static var prefix: String { "user_" }
	}
	
	struct InsensitiveUser: Hashable, Codable, Identifiable {
		typealias ID = PrefixedUUID<CaseInsensitiveUserIDPrefix>
		let id: ID
	}
	struct CaseInsensitiveUserIDPrefix: PrefixProtocol {
		static var prefix: String { "lower_user_" }
		static var isCaseSensitive: Bool { false }
	}
	
	func testDecodeWithInvalidIdPrefix() {
		let data = """
		{"id": "u_44607F67-DF9D-4ECD-8C8C-4254CCA1EBDC"}
		""".data(using: .utf8)!
		
		XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: data))
	}
	
	func testDecodeWithInvalidUUID() {
		let data = """
		{"id": "user_abc"}
		""".data(using: .utf8)!
		
		XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: data))
	}
	
	func testDecodeWithValidIdPrefix() {
		let data = """
		{"id": "user_FAED372B-1D04-4FC1-8D79-385C2F65FBFD"}
		""".data(using: .utf8)!
		
		XCTAssertNoThrow(try JSONDecoder().decode(User.self, from: data))
	}
	
	func testDecodeWithInvalidIdPrefixCaseInsensitive() {
		let data = """
		{"id": "U_56C68C54-510E-42CC-8253-106F7E251F53"}
		""".data(using: .utf8)!
		
		XCTAssertThrowsError(try JSONDecoder().decode(InsensitiveUser.self, from: data))
	}
	
	func testDecodeWithValidIdPrefixCaseInsensitive() {
		let data = """
		{"id": "lower_USER_4ED1FF78-B46F-4359-8C6B-F80103EAB6D9"}
		""".data(using: .utf8)!
		
		XCTAssertNoThrow(try JSONDecoder().decode(InsensitiveUser.self, from: data))
	}
	
	func testEncode() throws {
		let uuid = UUID()
		let user = User(id: PrefixedUUID(uuid: uuid))
		
		let data = try JSONEncoder().encode(user)
		let result = String(data: data, encoding: .utf8)
		let expected = "{\"id\":\"user_\(uuid.uuidString)\"}"
		
		XCTAssertEqual(result, expected)
	}
	
	func testPrefixedId() {
		let uuid = UUID()
		let id = PrefixedUUID<UserIDPrefix>(uuid: uuid)
		
		let result = id.prefixedId
		let expected = "user_\(uuid.uuidString)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testDescription() {
		let uuid = UUID()
		let id = PrefixedUUID<UserIDPrefix>(uuid: uuid)
		
		let result = String(describing: id)
		let expected = "user_\(uuid.uuidString)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testDebugDescription() {
		let uuid = UUID()
		let id = PrefixedUUID<UserIDPrefix>(uuid: uuid)
		
		let result = String(reflecting: id)
		let expected = "(user_)\(uuid.uuidString)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testRawValue() {
		let uuid = UUID()
		let id = PrefixedUUID<UserIDPrefix>(uuid: uuid)
		
		let result = id.rawValue
		let expected = "user_\(uuid.uuidString)"
		
		XCTAssertEqual(result, expected)
	}
	
	func testDecodeFromRawValue() {
		let id = PrefixedUUID<UserIDPrefix>()
		let result = PrefixedUUID<UserIDPrefix>(rawValue: id.rawValue)
		
		XCTAssertEqual(result, id)
	}
	
}
