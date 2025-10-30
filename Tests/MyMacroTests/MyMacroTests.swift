import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(FreezedMacroMacros)
import FreezedMacroMacros

let testMacros: [String: Macro.Type] = [
    "Freezed": CopyableMacro.self,
]
#endif

final class FreezedMacroTests: XCTestCase {    
    func testMacro() throws {
        #if canImport(FreezedMacroMacros)
        assertMacroExpansion(
            """
            @Freezed
            final class User {
                let id: Int
                let name: String
                let url: URL
                let optionalUrl: URL?
                let optionalName:String?
                let optionalId: Int?
                init(
                    id: Int,
                    name: String,
                    url: URL,
                    optionalUrl: URL?,
                    optionalName: String?,
                    optionalId: Int?
                ) {
                    self.id = id
                    self.name = name
                    self.url = url
                    self.optionalUrl = optionalUrl
                    self.optionalName = optionalName
                    self.optionalId = optionalId
                }
            }
            """,
            expandedSource: """
            
            final class User {
                let id: Int
                let name: String
                let url: URL
                let optionalUrl: URL?
                let optionalName:String?
                let optionalId: Int?
                init(
                    id: Int,
                    name: String,
                    url: URL,
                    optionalUrl: URL?,
                    optionalName: String?,
                    optionalId: Int?
                ) {
                    self.id = id
                    self.name = name
                    self.url = url
                    self.optionalUrl = optionalUrl
                    self.optionalName = optionalName
                    self.optionalId = optionalId
                }
            
                public func copyWith(
                    id: Int? = nil,
                    name: String? = nil,
                    url: URL? = nil,
                    optionalUrl: URL? = nil,
                    optionalName: String? = nil,
                    optionalId: Int? = nil
                ) -> User {
                    return User(
                        id: id ?? self.id,
                        name: name ?? self.name,
                        url: url ?? self.url,
                        optionalUrl: optionalUrl ?? self.optionalUrl,
                        optionalName: optionalName ?? self.optionalName,
                        optionalId: optionalId ?? self.optionalId
                    )
                }
            
                static func == (lhs: User, rhs: User) -> Bool {
                    lhs.id == rhs.id && lhs.name == rhs.name && lhs.url == rhs.url && lhs.optionalUrl == rhs.optionalUrl && lhs.optionalName == rhs.optionalName && lhs.optionalId == rhs.optionalId
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

}



