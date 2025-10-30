@attached(member, names: named(copyWith), named(==), named(hash), named(toString))
public macro Freezed() = #externalMacro(module: "FreezedMacroMacros", type: "CopyableMacro")
