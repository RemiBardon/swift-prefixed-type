//
//  PrefixProtocol.swift
//  Prefixed
//
//  Created by Rémi Bardon on 24/07/2021.
//

import Foundation

// MARK: - Prefix Protocol

/// The `protocol` used to define a new prefix.
///
/// - Warning: Do not make an existing `struct` conform to ``PrefixProtocol``:
///            ``PrefixProtocol`` sets custom `String` and debug descriptions which would override
///            the one you expect.
public protocol PrefixProtocol {
	
	/// The desired prefix.
	///
	/// - Remark: Having it as a `static` value means it will only be stored once in memory.
	static var prefix: String { get }
	
	/// A boolean indicating whether or not the prefix is case sensitive.
	///
	/// If set to `true`, `"user_abcdef"` will not match `"UsEr_abcdef"`.
	///
	/// - Important: Default value is `true`.
	static var isCaseSensitive: Bool { get }
	
}

// MARK: Default Values

extension PrefixProtocol {
	
	/// Default value is that prefixes are case sensitive.
	public static var isCaseSensitive: Bool { true }
	
}
