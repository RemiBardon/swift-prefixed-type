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

public extension Prefixed where Base == UUID {
	/// The `UUID` with its prefix.
	///
	/// - Remark: This is equivalent to ``prefixed``.
	var prefixedId: String { prefixed }

	/// The underlying (non prefixed) `UUID`.
	///
	/// - Remark: This is equivalent to ``base``.
	var uuid: UUID { base }

	/// Creates a new ``PrefixedUUID`` with a random `UUID`.
	init() {
		self.init(uuid: UUID())
	}

	/// Creates a new ``PrefixedUUID`` from the given `UUID`.
	init(uuid: UUID) {
		self.base = uuid
	}
}

// MARK: - Useful UUID Extensions

public extension UUID {
	func prefixed<P: PrefixProtocol>(by _: P.Type) -> PrefixedUUID<P> {
		PrefixedUUID<P>(uuid: self)
	}

	func prefixed<P: PrefixProtocol>() -> PrefixedUUID<P> {
		PrefixedUUID<P>(uuid: self)
	}
}
