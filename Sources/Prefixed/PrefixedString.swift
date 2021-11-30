//
//  PrefixedString.swift
//  Prefixed
//
//  Created by Rémi Bardon on 30/11/2021.
//

import Foundation

// MARK: - Prefixed String type alias

public typealias PrefixedString<Prefix: PrefixProtocol> = Prefixed<Prefix, String>

extension Prefixed where Base == String {
	
	public var string: String { base }
	
	public init() {
		self.init(string: "")
	}
	
	public init(string: String) {
		self.base = string
	}
	
}

// MARK: - Useful String Extensions

extension String {
	public func prefixed<P: PrefixProtocol>(by prefix: P.Type) -> PrefixedString<P> { .init(string: self) }
	public func prefixed<P: PrefixProtocol>() -> PrefixedString<P> { .init(string: self) }
}
