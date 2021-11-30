//
//  Prefixed.swift
//  Prefixed
//
//  Created by Rémi Bardon on 24/07/2021.
//

import Foundation

// MARK: - Prefixed struct

public struct Prefixed<Prefix: PrefixProtocol, Base: Hashable & Codable>: Hashable, Codable {
	
	public var prefixed: String { "\(Prefix.prefix)\(base)" }
	public let base: Base
	
	public init(base: Base) {
		self.base = base
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		var string = try container.decode(String.self)
		
		// Test prefix
		if Prefix.isCaseSensitive {
			guard string.hasPrefix(Prefix.prefix) else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "'\(string)' is not prefixed by '\(Prefix.prefix)'"
				)
			}
		} else {
			guard string.prefix(Prefix.prefix.count).lowercased() == Prefix.prefix.lowercased() else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "'\(string)' is not prefixed by '\(Prefix.prefix)' (case insensitive)"
				)
			}
		}
		
		// Remove prefix
		string.removeFirst(Prefix.prefix.count)
		
		// Try to decode `Bool` or `Numeric` types
		// Note: We cannot use `if Base.self is Numeric.Type` because
		// > Protocol 'Numeric' can only be used as a generic constraint because it has Self or associated type requirements
		var data = Data(string.utf8)
		if let base = try? JSONDecoder().decode(Base.self, from: data) {
			self.init(base: base)
			return
		}
		// Try to decode `String`
		data = Data("\"\(string)\"".utf8)
		guard let base = try? JSONDecoder().decode(Base.self, from: data) else {
			throw DecodingError.dataCorruptedError(
				in: container,
				debugDescription: "'\(string)' is not a valid `\(Base.self)`"
			)
		}
		
		self.init(base: base)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(prefixed)
	}
	
}

// MARK: - Additional Protocol Conformances

extension Prefixed: CustomStringConvertible {
	public var description: String { prefixed }
}

extension Prefixed: CustomDebugStringConvertible {
	public var debugDescription: String { "(\(Prefix.prefix))\(base)" }
}

extension Prefixed: RawRepresentable {
	
	public init?(rawValue: String) {
		var string = rawValue
		
		// Test prefix
		if Prefix.isCaseSensitive {
			guard string.hasPrefix(Prefix.prefix) else {
				return nil
			}
		} else {
			guard string.prefix(Prefix.prefix.count).lowercased() == Prefix.prefix.lowercased() else {
				return nil
			}
		}
		
		// Remove prefix
		string.removeFirst(Prefix.prefix.count)
		
		// Try to decode `Bool` or `Numeric` types
		// Note: We cannot use `if Base.self is Numeric.Type` because
		// > Protocol 'Numeric' can only be used as a generic constraint because it has Self or associated type requirements
		var data = Data(string.utf8)
		if let base = try? JSONDecoder().decode(Base.self, from: data) {
			self.init(base: base)
			return
		}
		// Try to decode `String`
		data = Data("\"\(string)\"".utf8)
		guard let base = try? JSONDecoder().decode(Base.self, from: data) else {
			return nil
		}
		
		self.init(base: base)
	}
	
	public var rawValue: String { prefixed }
	
}

extension Prefixed: LosslessStringConvertible {
	
	public init?(_ description: String) {
		self.init(rawValue: description)
	}
	
}
