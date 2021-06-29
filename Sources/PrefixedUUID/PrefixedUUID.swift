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

// MARK: - UUID Prefix Protocol

public protocol UUIDPrefix: CustomStringConvertible, CustomDebugStringConvertible {
	
	static var uuidPrefix: String { get }
	static var uuidPrefixIsCaseSensitive: Bool { get }
	
}

extension UUIDPrefix {
	
	// MARK: Default Values
	
	public static var uuidPrefixIsCaseSensitive: Bool { true }
	
	// MARK: Additional Protocol Conformances
	
	public var description: String { Self.uuidPrefix }
	
	public var debugDescription: String {
		let prefixCase = Self.uuidPrefixIsCaseSensitive ? "case-sensitive" : "case-insensitive"
		return "\(Self.self) (\"\(Self.uuidPrefix)\", \(prefixCase))"
	}
	
}

// MARK: - Useful UUID Extensions

extension UUID {
	
	public func prefixed<P: UUIDPrefix>(by prefix: P.Type) -> PrefixedUUID<P> { .init(uuid: self) }
	public func prefixed<P: UUIDPrefix>() -> PrefixedUUID<P> { .init(uuid: self) }
	
}
