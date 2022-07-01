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

extension Prefixed where Base == String {
	
	/// The underlying (non prefixed) `String`.
	///
	/// - Remark: This is equivalent to ``base``.
	public var string: String { base }
	
	/// Creates a new ``PrefixedString`` with an empty `String`.
	public init() {
		self.init(string: "")
	}
	
	/// Creates a new ``PrefixedString`` from the given `String`.
	public init(string: String) {
		self.base = string
	}
	
}

// MARK: - Useful String Extensions

extension String {
	public func prefixed<P: PrefixProtocol>(by prefix: P.Type) -> PrefixedString<P> { .init(string: self) }
	public func prefixed<P: PrefixProtocol>() -> PrefixedString<P> { .init(string: self) }
}
