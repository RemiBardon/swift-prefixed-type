//
//  PrefixedString.swift
//  Prefixed
//
//  Created by Rémi Bardon on 30/11/2021.
//

import Foundation

// MARK: - Prefixed String type alias

/// Convenience type alias for ``Prefixed`` when ``Prefixed``.`Base` is `String`.
public typealias PrefixedString<Prefix: PrefixProtocol> = Prefixed<Prefix, String>

public extension Prefixed where Base == String {
	/// The underlying (non prefixed) `String`.
	///
	/// - Remark: This is equivalent to ``base``.
	var string: String { base }

	/// Creates a new ``PrefixedString`` with an empty `String`.
	init() {
		self.init(string: "")
	}

	/// Creates a new ``PrefixedString`` from the given `String`.
	init(string: String) {
		self.base = string
	}
}

// MARK: - Useful String Extensions

public extension String {
	func prefixed<P: PrefixProtocol>(by _: P.Type) -> PrefixedString<P> {
		PrefixedString<P>(string: self)
	}

	func prefixed<P: PrefixProtocol>() -> PrefixedString<P> {
		PrefixedString<P>(string: self)
	}
}
