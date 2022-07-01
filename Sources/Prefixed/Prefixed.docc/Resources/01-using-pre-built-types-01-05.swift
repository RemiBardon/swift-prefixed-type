import Foundation
import Prefixed

struct UserIDPrefix: PrefixProtocol {
	static var prefix: String { "user_" }
	static var isCaseSensitive: Bool { false }
}

struct User: Identifiable {
	typealias ID = PrefixedUUID<UserIDPrefix>

	let id: ID
	var name: String
}
