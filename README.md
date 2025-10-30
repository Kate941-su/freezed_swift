# FreezedMacro

A Swift macro library inspired by [Dart's Freezed package](https://pub.dev/packages/freezed) that automatically generates immutable data classes with copy methods and equality operators.

## Features

- 🚀 **Automatic Code Generation**: Generate boilerplate code for immutable data classes
- 📋 **Copy Methods**: Create `copyWith` methods for easy object copying with selective property updates
- ⚖️ **Equality Support**: Automatic `Equatable` conformance with `==` operator implementation
- 🔒 **Immutable by Design**: Encourages immutable data structures following functional programming principles
- 🎯 **Type Safety**: Full Swift type safety with compile-time code generation

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/FreezedMacro.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version and add to your target

## Usage

### Basic Example

```swift
import FreezedMacro

@Freezed
final class User {
    let id: Int
    let name: String
    let email: String
    let isActive: Bool
    let createdAt: Date
    let optionalBio: String?
    
    init(
        id: Int,
        name: String,
        email: String,
        isActive: Bool,
        createdAt: Date,
        optionalBio: String?
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.isActive = isActive
        self.createdAt = createdAt
        self.optionalBio = optionalBio
    }
}
```

### What Gets Generated

The `@Freezed` macro automatically generates:

#### 1. Copy Method
```swift
public func copyWith(
    id: Int? = nil,
    name: String? = nil,
    email: String? = nil,
    isActive: Bool? = nil,
    createdAt: Date? = nil,
    optionalBio: String? = nil
) -> User {
    return User(
        id: id ?? self.id,
        name: name ?? self.name,
        email: email ?? self.email,
        isActive: isActive ?? self.isActive,
        createdAt: createdAt ?? self.createdAt,
        optionalBio: optionalBio ?? self.optionalBio
    )
}
```

#### 2. Equality Operator
```swift
static func == (lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id && 
           lhs.name == rhs.name && 
           lhs.email == rhs.email && 
           lhs.isActive == rhs.isActive && 
           lhs.createdAt == rhs.createdAt && 
           lhs.optionalBio == rhs.optionalBio
}
```

### Usage Examples

#### Creating and Copying Objects

```swift
// Create a user
let user = User(
    id: 1,
    name: "John Doe",
    email: "john@example.com",
    isActive: true,
    createdAt: Date(),
    optionalBio: "Software Developer"
)

// Create a copy with updated name
let updatedUser = user.copyWith(name: "Jane Doe")

// Create a copy with multiple changes
let deactivatedUser = user.copyWith(
    name: "John Smith",
    isActive: false,
    optionalBio: nil
)

// Create a copy with only one property changed
let userWithNewEmail = user.copyWith(email: "newemail@example.com")
```

#### Equality Comparison

```swift
let user1 = User(id: 1, name: "John", email: "john@example.com", isActive: true, createdAt: Date(), optionalBio: nil)
let user2 = User(id: 1, name: "John", email: "john@example.com", isActive: true, createdAt: Date(), optionalBio: nil)

print(user1 == user2) // true

let user3 = user1.copyWith(name: "Jane")
print(user1 == user3) // false
```

### Advanced Examples

#### Data Models for API Responses

```swift
@Freezed
final class ApiResponse<T> {
    let data: T
    let status: Int
    let message: String
    let timestamp: Date
    let errors: [String]?
    
    init(data: T, status: Int, message: String, timestamp: Date, errors: [String]?) {
        self.data = data
        self.status = status
        self.message = message
        self.timestamp = timestamp
        self.errors = errors
    }
}

// Usage
let response = ApiResponse(
    data: ["user1", "user2"],
    status: 200,
    message: "Success",
    timestamp: Date(),
    errors: nil
)

// Update with new data
let updatedResponse = response.copyWith(
    data: ["user1", "user2", "user3"],
    message: "Updated successfully"
)
```

#### Configuration Objects

```swift
@Freezed
final class AppConfig {
    let apiBaseURL: String
    let timeout: TimeInterval
    let enableLogging: Bool
    let maxRetries: Int
    let debugMode: Bool?
    
    init(apiBaseURL: String, timeout: TimeInterval, enableLogging: Bool, maxRetries: Int, debugMode: Bool?) {
        self.apiBaseURL = apiBaseURL
        self.timeout = timeout
        self.enableLogging = enableLogging
        self.maxRetries = maxRetries
        self.debugMode = debugMode
    }
}

// Usage
let config = AppConfig(
    apiBaseURL: "https://api.example.com",
    timeout: 30.0,
    enableLogging: true,
    maxRetries: 3,
    debugMode: nil
)

// Create debug configuration
let debugConfig = config.copyWith(
    debugMode: true,
    enableLogging: false
)
```

## Requirements

- Swift 5.9+
- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+

## How It Works

The `@Freezed` macro analyzes your class or struct and:

1. **Extracts Properties**: Identifies all stored properties (both `let` and `var`)
2. **Handles Optionality**: Preserves the original optionality of properties
3. **Generates Copy Method**: Creates a `copyWith` method that allows selective property updates
4. **Implements Equality**: Generates `Equatable` conformance with proper equality checking

## Limitations

- Only works with classes and structs
- Properties must have explicit type annotations
- Static properties are excluded from generation
- Currently generates methods for all stored properties

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Inspiration

This library is inspired by the excellent [Freezed package](https://pub.dev/packages/freezed) for Dart, which provides similar functionality for immutable data classes in the Dart ecosystem.

## Acknowledgments

- [Swift Syntax](https://github.com/apple/swift-syntax) for providing the macro infrastructure
- [Dart Freezed](https://pub.dev/packages/freezed) for the inspiration and design patterns
