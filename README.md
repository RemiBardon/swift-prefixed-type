# `PrefixedUUID`: A type-safe, `Codable` prefixed `UUID`

## 🤔 What is `PrefixedUUID` for?

`UUID`s are great, you can use them everywhere… but when you do so,
it starts being hard to recognize where a `UUID` comes from.

A common pattern is to add readable prefixes to the `UUID`s.
This way, you can have `user_ee505428-a17b-4935-b81c-266b81a63515`
and `post_d58a3f88-0493-458d-bd4b-a6ca4a2cc98c` for example,
making it easy to find which is which.

Writing this library, I wanted to keep it very simple and straight-forward.
I also wanted the `PrefixedUUID`s to be type-safe, meaning a `UUID` prefixed with `user_`
could not be used instead of a `UUID` prefixed by `post_`.

## 🛠 Features

- I wrote `PrefixedUUID`s so that they take (almost) as little space in memory as `UUID`s do.
  `String` prefixes are stored once ever and dashes in the `UUID` are not stored.
  The only thing that's stored for each `PrefixedUUID` is a `UUID` (which directly stores bytes).
  
## 📦 Installation

### Using `Package.swift` in another Swift Package

To use this package in a project, import the `"prefixed-uuid"` package like so:

```swift
dependencies: [
	// Other dependencies
	.package(
		name: "prefixed-uuid",
		url: "https://github.com/RemiBardon/swift-prefixed-uuid",
		.upToNextMajor(from: "1.0.0")
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
			.product(name: "PrefixedUUID", package: "prefixed-uuid"),
		]
	),
	// ...
]
```

### In a full project

To add `PrefixedUUID` to your project, go to your project's configuration,
then go to the "Swift Packages" tab, click <kbd>+</kbd> and follow XCode's instructions
<small>(Assuming you use XCode)</small>. When you're asked for a URL, enter
<https://github.com/RemiBardon/swift-prefixed-uuid>.

## 🧑‍💻 Usage

First, create a type conforming to `UUIDPrefix`:

```swift
struct UserIDPrefix: UUIDPrefix {
	static var uuidPrefix: String { "user_" }
}
```

If you want the prefix to be case-insensitive, you can override the default (`true`) value:

```swift
struct CaseInsensitiveUserIDPrefix: UUIDPrefix {
	static var uuidPrefix: String { "lower_user_" }
	static var uuidPrefixIsCaseSensitive: Bool { false }
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

- Do not make an existing `struct` conform to `UUIDPrefix`:
  `UUIDPrefix` sets custom `String` and debug descriptions which would override the one you expect.

## 🗺 Roadmap

As you would expect from a package this small, it is not actively developed.
However, I still have a few things to add:

- [ ] Swift documentation comments, to make the package more understandable
- [ ] Continuous Integration, to be sure the package runs in all environments
- [ ] A documentation page
- [ ] (Installation guides for older Swift Package Manager versions)
- [ ] (CONTRIBUTING guidelines)

## ⚖️ License

This package is provided under MIT License.
