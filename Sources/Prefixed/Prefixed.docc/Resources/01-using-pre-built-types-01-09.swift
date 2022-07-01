import Foundation
import Prefixed

struct UserIDPrefix: PrefixProtocol {
	static var prefix: String { "user_" }
	static var isCaseSensitive: Bool { false }
}

struct User: Codable, Identifiable {
	typealias ID = PrefixedUUID<UserIDPrefix>

	let id: ID
	var name: String
}

let user = User(
	id: User.ID(),
	name: "Rémi Bardon"
)
print(user)
// User(id: (user_)D9BD19D6-6DC5-477E-BC2D-7D6753F09079, name: "Rémi Bardon")

let encoder = JSONEncoder()
let data = try! encoder.encode(user)
let string = String(data: data, encoding: .utf8)
print(string)
// {"id":"user_D9BD19D6-6DC5-477E-BC2D-7D6753F09079","name":"Rémi Bardon"}

let decoder = JSONDecoder()
let data2 = string.data(using: .utf8)
let user2 = try! decoder.decode(User.self, from: data2)
print(user2 == user)
// true
