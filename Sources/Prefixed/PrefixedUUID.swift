//
//  PrefixedUUID.swift
//  Prefixed
//
//  Created by Rémi Bardon on 29/06/2021.
//

import Foundation

// MARK: - Prefixed UUID type alias

/// Convenience type alias for ``Prefixed`` when ``Prefixed``.`Base` is `UUID`.
public typealias PrefixedUUID<Prefix: PrefixProtocol> = Prefixed<Prefix, UUID>

extension Prefixed where Base == UUID {
	
	/// The `UUID` with its prefix.
	///
	/// - Remark: This is equivalent to ``prefixed``.
	public var prefixedId: String { prefixed }
	
	/// The underlying (non prefixed) `UUID`.
	///
	/// - Remark: This is equivalent to ``base``.
	public var uuid: UUID { base }
	
	/// Creates a new ``PrefixedUUID`` with a random `UUID`.
	public init() {
		self.init(uuid: UUID())
	}
	
	/// Creates a new ``PrefixedUUID`` from the given `UUID`.
	public init(uuid: UUID) {
		self.base = uuid
	}
	
}

// MARK: - Useful UUID Extensions

extension UUID {
	public func prefixed<P: PrefixProtocol>(by prefix: P.Type) -> PrefixedUUID<P> { .init(uuid: self) }
	public func prefixed<P: PrefixProtocol>() -> PrefixedUUID<P> { .init(uuid: self) }
}
