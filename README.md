# `Prefixed`: A type-safe, `Codable` `struct` for prefixed types

## 🤔 What is `Prefixed` for?

`UUID`s are great, you can use them everywhere… but when you do so,
it starts being hard to recognize where a `UUID` comes from.

A common pattern is to add readable prefixes to the `UUID`s.
This way, you can have `user_ee505428-a17b-4935-b81c-266b81a63515`
and `post_d58a3f88-0493-458d-bd4b-a6ca4a2cc98c` for example,
making it easy to find which is which.

Writing this library, I wanted to keep it very simple and straight-forward.
I also wanted the `PrefixedUUID`s to be type-safe, meaning a `UUID` prefixed with `user_`
could not be used instead of a `UUID` prefixed by `post_`.

After writing `PrefixedUUID`, I realized prefixed `UUID`s are just a subset
of all the types we could want to prefix. That's why I made it more generic,
by creating the `Prefixed` `struct`.

## 🛠 Features

> These are the features of `PrefixedUUID`s, but you can say the same with any other prefixed type.

- **Type safety:** `User.ID != Post.ID`, even though they are stored the same way
- **`Codable`:** (`Encodable & Decodable`) conformance
- **Practical:** `PrefixedUUID`s allow you to access the underlying `UUID` or the prefixed `String`,
  without storing anything more in memory or requiring expensive computations.
- **Convenient:** Foundation's `UUID` extensions make it easy to work with `PrefixedUUID`s
- **Type inference:** Most of the time, you don't need to make associated types explicit
- **Lightweight:** `PrefixedUUID`s take (almost) as little space in memory as `UUID`s do.
  `String` prefixes are stored once ever and dashes in the `UUID` are not stored.
  The only thing that's stored for each `PrefixedUUID` is a `UUID` (which directly stores bytes).
- **Case (in)sensitive:** By default, prefixes are case sensitive, but with a simple option,
  you can choose for a prefix to be case insensitive.
- **Debugging:** Failing to decode a `Prefixed` type shows a human-readable error:
  - `"'usr_abcdef' is not prefixed by 'user_'"`
  - `"'USR_MONPQR' is not prefixed by 'user_' (case insensitive)"`
  - `"user_ABCD"` with a `Prefixed` `Int` => <code>"'ABCD' is not a valid \`Int\`"</code>
  - `"user_56C68C54"` with a `Prefixed` `UUID` => <code>"'56C68C54' is not a valid \`UUID\`"</code>

## 📦 Installation

### Using `Package.swift` in another Swift Package

To use this package in a project, import the `"prefixed-uuid"` package like so:

```swift
dependencies: [
	// Other dependencies
	.package(
		name: "prefixed",
		url: "https://github.com/RemiBardon/swift-prefixed-type",
		.upToNextMajor(from: "2.0.0")
	),
],
```

Then add it to your target like so:

```swift
targets: [
	// ...
	.target(
		name: "<YourTarget>",
		dependencies: [
			// Other dependencies
			.product(name: "Prefixed", package: "prefixed"),
		]
	),
	// ...
]
```

### In a full project

To add `Prefixed` to your project, go to your project's configuration,
then go to the <kbd>Swift Packages</kbd> tab, click <kbd>+</kbd> and follow XCode's instructions
<small>(Assuming you use XCode)</small>. When you're asked for a URL, enter
<https://github.com/RemiBardon/swift-prefixed-type>.

## 🧑‍💻 Usage

> The following uses `PrefixedUUID`s, but you can use `Prefixed<Prefix, Base>` instead if you want.

First, create a type conforming to `PrefixProtocol`:

```swift
struct UserIDPrefix: PrefixProtocol {
	static var prefix: String { "user_" }
}
```

If you want the prefix to be case-insensitive, you can override the default (`true`) value:

```swift
struct CaseInsensitiveUserIDPrefix: PrefixProtocol {
	static var prefix: String { "lower_user_" }
	static var isCaseSensitive: Bool { false }
}
```

Then, use your new type as you would normally do:

```swift
struct User: Codable, Identifiable {
	typealias ID = PrefixedUUID<UserIDPrefix>
	let id: ID
}
```

> `Identifiable` is not necessary, it's just here as a good practice.
> `Codable` is not necessary either, but you can use it: `PrefixedUUID` conforms to `Codable`.

There are many ways to create a `PrefixedUUID`:

- Using the verbose initializer:
  
  ```swift
  let prefixedUUID = PrefixedUUID<UserIDPrefix>(uuid: UUID())
  ```
  
- Using the default value (`UUID()`):
  
  ```swift
  let prefixedUUID = PrefixedUUID<UserIDPrefix>()
  ```
  
- Using the convenient `UUID` extensions:
  
  ```swift
  let prefixedUUID = UUID().prefixed(by: UserIDPrefix.self)
  ```
  
- The compiler can infer the type of your `UUIDPrefix`, so most of the time you just have to use `.prefixed()`:
  
  ```swift
  let prefixedUUID: PrefixedUUID<UserIDPrefix> = UUID().prefixed()
  ```

## ⚠️ Warnings

- Do not make an existing `struct` conform to `PrefixProtocol`:
  `PrefixProtocol` sets custom `String` and debug descriptions which would override the one you expect.

## ❌ Major versions migrations

### From `1.X.X` to `2.X.X`

- Package has been renamed from `prefixed-uuid` to `prefixed`
- Package library has been renamed from `PrefixedUUID` to `Prefixed`
- `UUIDPrefix` has been renamed to `PrefixProtocol`
	- `UUIDPrefix.uuidPrefix` has been renamed to `PrefixProtocol.prefix`
	- `UUIDPrefix.uuidPrefixIsCaseSensitive` has been renamed to `PrefixProtocol.isCaseSensitive`

## 🗺 Roadmap

As you would expect from a package this small, it is not actively developed.
However, I still have a few things to add:

- [x] Generic `Prefixed` `struct`, to be `UUID`-independent
- [ ] Swift documentation comments, to make the package more understandable
- [ ] Continuous Integration, to be sure the package runs in all environments
- [ ] Documentation page
- [ ] (Installation guides for older Swift Package Manager versions)
- [ ] (CONTRIBUTING guidelines)

## ⚖️ License

This package is provided under MIT License. For more information, see [LICENSE](./LICENSE).
