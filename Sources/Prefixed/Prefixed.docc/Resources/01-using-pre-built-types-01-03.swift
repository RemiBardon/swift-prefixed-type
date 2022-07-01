import Foundation
import Prefixed

struct UserIDPrefix: PrefixProtocol {
	
	static var prefix: String { "user_" }
	static var isCaseSensitive: Bool { false }
	
}
