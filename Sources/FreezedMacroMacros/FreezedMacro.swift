import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct CopyableMacro: MemberMacro {
    public static func expansion(
            of node: AttributeSyntax,
            providingMembersOf declaration: some DeclGroupSyntax,
            in context: some MacroExpansionContext
        ) throws -> [DeclSyntax] {
            // A: Generate copyWith method
            // 1. Get stored properties list
            let properties = declaration.memberBlock.members.compactMap { member -> (name: TokenSyntax, type: TypeSyntax, isOptional: Bool)? in
                guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                      (varDecl.bindingSpecifier.text == "let" || varDecl.bindingSpecifier.text == "var"),
                      let binding = varDecl.bindings.first,
                      let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
                      let type = binding.typeAnnotation?.type
                else {
                    return nil
                }

                if let accessorBlock = binding.accessorBlock {
                    if let accessorList = accessorBlock.as(AccessorBlockSyntax.self) {
                        return nil
                    }
                }

                if varDecl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) }) {
                    return nil
                }
    
                if varDecl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.private) }) {
                    return nil
                }
                
                let isOptional = type.is(OptionalTypeSyntax.self)
                return (name: identifier, type: type, isOptional: isOptional)
            }
            // 2: Generate arguments list
            let parameterList: [String] = properties.map { property in
                if property.isOptional {
                    return "\(property.name.text): \(property.type.description) = nil"
                } else {
                    return "\(property.name.text): \(property.type.description.replacing(" ", with: ""))? = nil"
                }

            }
            let parameters = parameterList.joined(separator: ", \n")
            
            // 3: Generate initialiser with arguments
            let initializerArgs: [String] = properties.map { property in
                return "\(property.name.text): \(property.name.text) ?? self.\(property.name.text)"
            }
            let arguments = initializerArgs.joined(separator: ", \n")
            
            let declarationName: String
            if let classDecl = declaration.as(ClassDeclSyntax.self) {
                declarationName = classDecl.name.text
            } else if let structDecl = declaration.as(StructDeclSyntax.self) {
                declarationName = structDecl.name.text
            } else {
                throw NSError()
            }
            
            // 4: Generate the Equtable method
            var equtableString: String = ""
            let length = properties.count
            for i in 0..<length {
                if i == (length - 1) {
                    equtableString += "lhs.\(properties[i].name.text) == rhs.\(properties[i].name.text)"
                } else {
                    equtableString += "lhs.\(properties[i].name.text) == rhs.\(properties[i].name.text) && "
                }
            }

            var hashValueString: String = ""
            properties.forEach { property in
                hashValueString += "hasher.combine(\(property.name.text))\n"
            }
            
            // 5: Generate arguments list
            let hashMethod: DeclSyntax = """
                func hash(into hasher: inout Hasher) {
                    \(raw: hashValueString)
                }
            """
            
            // 6: Generate the final method
            let copyMethod: DeclSyntax =
            """
            public func copyWith(
                \(raw: parameters)
            ) -> \(raw: declarationName) {
                return \(raw: declarationName)(
                    \(raw: arguments)
                )
            }
            """
            
            let equtableMethod: DeclSyntax = """
            static func == (lhs: \(raw: declarationName), rhs: \(raw: declarationName)) -> Bool {
                \(raw: equtableString)
            }
            """
            
            return [copyMethod, equtableMethod, hashMethod]
        }
}




@main
struct FreezedMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CopyableMacro.self,
    ]
}
