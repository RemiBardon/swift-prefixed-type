//
//  PrefixProtocol.swift
//  Prefixed
//
//  Created by Rémi Bardon on 24/07/2021.
//

import Foundation

// MARK: - Prefix Protocol

public protocol PrefixProtocol {
	static var prefix: String { get }
	static var isCaseSensitive: Bool { get }
}

// MARK: Default Values

extension PrefixProtocol {
	public static var isCaseSensitive: Bool { true }
}
