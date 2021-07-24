//
//  PrefixedUUID.swift
//  Prefixed
//
//  Created by Rémi Bardon on 29/06/2021.
//

import Foundation

// MARK: - Prefixed UUID type alias

public typealias PrefixedUUID<Prefix: PrefixProtocol> = Prefixed<Prefix, UUID>

extension Prefixed where Base == UUID {
	
	public var prefixedId: String { prefixed }
	public var uuid: UUID { base }
	
	public init() {
		self.init(uuid: UUID())
	}
	
	public init(uuid: UUID) {
		self.base = uuid
	}
	
}

// MARK: - Useful UUID Extensions

extension UUID {
	public func prefixed<P: PrefixProtocol>(by prefix: P.Type) -> PrefixedUUID<P> { .init(uuid: self) }
	public func prefixed<P: PrefixProtocol>() -> PrefixedUUID<P> { .init(uuid: self) }
}
