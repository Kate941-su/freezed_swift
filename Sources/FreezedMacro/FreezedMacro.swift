@attached(member, names: named(copyWith), named(==), named(hash))
public macro Freezed() = #externalMacro(module: "FreezedMacroMacros", type: "CopyableMacro")
