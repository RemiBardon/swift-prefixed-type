import Foundation

// MARK: - Prefixed UUID struct

public struct PrefixedUUID<Prefix: UUIDPrefix>: Hashable, Codable {
	
	public var fullId: String { "\(Prefix.uuidPrefix)\(uuid.uuidString)" }
	public let uuid: UUID
	
	public init() {
		self.init(uuid: UUID())
	}
	
	public init(uuid: UUID) {
		self.uuid = uuid
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		var string = try container.decode(String.self)
		
		if Prefix.uuidPrefixIsCaseSensitive {
			guard string.hasPrefix(Prefix.uuidPrefix) else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "'\(string)' is not prefixed by '\(Prefix.uuidPrefix)'"
				)
			}
		} else {
			guard string.prefix(Prefix.uuidPrefix.count).lowercased() == Prefix.uuidPrefix.lowercased() else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "'\(string)' is not prefixed by '\(Prefix.uuidPrefix)' (case insensitive)"
				)
			}
		}
		
		string.removeFirst(Prefix.uuidPrefix.count)
		guard let id = UUID(uuidString: string) else {
			throw DecodingError.dataCorruptedError(
				in: container,
				debugDescription: "'\(string)' is not a valid UUID"
			)
		}
		
		self.init(uuid: id)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(fullId)
	}
	
}

// MARK: Additional Protocol Conformances

extension PrefixedUUID: CustomStringConvertible {
	public var description: String { fullId }
}

extension PrefixedUUID: CustomDebugStringConvertible {
	public var debugDescription: String { "[\(Prefix.uuidPrefix)]\(uuid.uuidString)" }
}

extension PrefixedUUID: RawRepresentable {
	
	public init?(rawValue: String) {
		var string = rawValue
		
		if Prefix.uuidPrefixIsCaseSensitive {
			guard string.hasPrefix(Prefix.uuidPrefix) else {
				return nil
			}
		} else {
			guard string.prefix(Prefix.uuidPrefix.count).lowercased() == Prefix.uuidPrefix.lowercased() else {
				return nil
			}
		}
		
		string.removeFirst(Prefix.uuidPrefix.count)
		guard let id = UUID(uuidString: string) else {
			return nil
		}
		
		self.init(uuid: id)
	}
	
	public var rawValue: String { fullId }
	
}

// MARK: - UUID Prefix Protocol

public protocol UUIDPrefix {
	static var uuidPrefix: String { get }
	static var uuidPrefixIsCaseSensitive: Bool { get }
}

// MARK: Default Values

extension UUIDPrefix {
	public static var uuidPrefixIsCaseSensitive: Bool { true }
}

// MARK: - Useful UUID Extensions

extension UUID {
	public func prefixed<P: UUIDPrefix>(by prefix: P.Type) -> PrefixedUUID<P> { .init(uuid: self) }
	public func prefixed<P: UUIDPrefix>() -> PrefixedUUID<P> { .init(uuid: self) }
}
