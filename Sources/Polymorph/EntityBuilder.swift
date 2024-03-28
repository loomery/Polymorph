@resultBuilder
public struct EntityBuilder {
    public static func buildBlock(_ components: Library.Entity...) -> [Library.Entity] {
        components
    }
}

@resultBuilder
public struct AttributeBuilder {
    public typealias Attribute = EntityAttribute
    public static func buildBlock(_ components: (any Attribute)...) -> [any Attribute] {
        components
    }
}
