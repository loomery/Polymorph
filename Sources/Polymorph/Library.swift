import RealityKit

/// A namespace for wrapping RealityKit's types.
public struct Library { }

public extension Library {
    struct Entity: Sendable {
        fileprivate var entity: RealityKit.Entity?
        let name: String
        var attributes: [any EntityAttribute]
        
        /// The DSL's wrapper for a RealityKit `Entity` containing an `AttributeBuilder` for customizable attributes.
        /// - Parameters:
        ///   - name: Name of the entity
        ///   - attributes: The `resultBuilder` for the associated attributes
        public init(named name: String, @AttributeBuilder _ attributes: () -> [any EntityAttribute]) {
            self.name = name
            self.attributes = attributes()
        }
        
        /// Attatches the RealityKit `Enitity` to the Library `Enitity`.
        /// - Parameter entity: The RealityKit `Enitity` to attach
        /// - Returns: A copy of `self` with the `Entity` attached
        public func withEntity(_ entity: RealityKit.Entity) -> Self {
            guard let child = entity.findEntity(named: name) else {
                print("Couldn't find child entity \(name)")
                return self
            }
            
            var copy = self
            copy.entity = entity
            
            copy.attributes = copy.attributes.map {
                $0.with(entity: child)
            }
            return copy
        }
    }
}

public extension Library {
    /// Get the parameter value for a given name and entity.
    /// - Parameters:
    ///   - name: The name of the parameter.
    ///   - entity: The entity to get the parameter from.
    ///   - geoSubsetIndex: The index of the geometry subset.
    ///   - Returns: The parameter value, or nil if not found.
    ///   - Note: This function is generic and can be used to get different types of parameters.
    ///   - Example:
    ///     ```swift
    ///     let color: CGColor? = getParameter(named: "Color", for: entity, atSubsetIndex: 0)
    ///     ```
    ///     - Use caution when casting to the expected type.
    ///     - Note: This function is not thread-safe and should be called on the main thread.
    static func getParameter<T: Sendable>(
        named name: String,
        for entity: RealityKit.Entity?,
        atSubsetIndex geoSubsetIndex: Array.Index
    ) -> T? {
        guard
            let material = entity?.shaderGraphMaterial(at: geoSubsetIndex),
            material.hasMaterialParameter(named: name)
        else { return nil }
        
        switch material.getParameter(name: name) {
        case let .color(value): return value as? T
        case let .bool(value): return value as? T
        case let .float(value): return value as? T
        case let .int(value): return value as? T
        case let .float2x2(value): return value as? T
        case let .float3x3(value): return value as? T
        case let .float4x4(value): return value as? T
        case let .texture(value): return value as? T
        case let .textureResource(value): return value as? T
        case let .simd2Float(value): return value as? T
        case let .simd3Float(value): return value as? T
        case let .simd4Float(value): return value as? T
        default: return nil
        }
    }
    /// Get the parameter value for a given name and entity asynchronously.
    /// - Parameters:
    ///  - name: The name of the parameter.
    ///  - entity: The entity to get the parameter from.
    ///  - geoSubsetIndex: The index of the geometry subset.
    ///  - Returns: The parameter value, or nil if not found.
    ///  - Note: This function is generic and can be used to get different types of parameters.
    ///  - Example:
    ///   ```swift
    ///   let color: CGColor? = await getParameter(named: "Color", for: entity, atSubsetIndex: 0)
    ///   ```
    static func getParameter<T: Sendable>(
        named name: String,
        for entity: RealityKit.Entity?,
        atSubsetIndex geoSubsetIndex: Array.Index
    ) async -> T? {
        guard
            let material = await entity?.shaderGraphMaterial(at: geoSubsetIndex),
            material.hasMaterialParameter(named: name)
        else { return nil }
        
        switch material.getParameter(name: name) {
        case let .color(value): return value as? T
        case let .bool(value): return value as? T
        case let .float(value): return value as? T
        case let .int(value): return value as? T
        case let .float2x2(value): return value as? T
        case let .float3x3(value): return value as? T
        case let .float4x4(value): return value as? T
        case let .texture(value): return value as? T
        case let .textureResource(value): return value as? T
        case let .simd2Float(value): return value as? T
        case let .simd3Float(value): return value as? T
        case let .simd4Float(value): return value as? T
        default: return nil
        }
    }
    /// Set the parameter value for a given name and entity.
    /// - Parameters:
    ///  - name: The name of the parameter.
    ///  - value: The value to set.
    ///  - entity: The entity to set the parameter on.
    ///  - geoSubsetIndex: The index of the geometry subset.
    ///  - Throws: An error if the parameter cannot be set.
    ///  - Note: This function is generic and can be used to set different types of parameters.
    ///  - Example:
    ///   ```swift
    ///   let color: Color = .red
    ///   setParameter(named: "Color", value: .color(color), for: entity, atSubsetIndex: 0)
    ///   ```
    ///   - Use caution when casting to the expected type.
    ///   - Warning: This function may throw an error if the parameter cannot be set.
    static func setParameter(
        named name: String,
        value: MaterialParameters.Value,
        for entity: RealityKit.Entity?,
        atSubsetIndex geoSubsetIndex: Array.Index
    ) throws {
        guard
            let material = entity?.shaderGraphMaterial(at: geoSubsetIndex),
            material.hasMaterialParameter(named: name)
        else { return }
        
        try entity?.update(shaderGraphMaterial: material, geoSubsetIndex: geoSubsetIndex) { mat in
            try mat.setParameter(name: name, value: value)
        }
    }
    /// Set the parameter value for a given name and entity asynchronously.
    /// - Parameters:
    /// - name: The name of the parameter.
    /// - value: The value to set.
    /// - entity: The entity to set the parameter on.
    /// - geoSubsetIndex: The index of the geometry subset.
    /// - Throws: An error if the parameter cannot be set.
    /// - Note: This function is generic and can be used to set different types of parameters.
    /// - Example:
    /// ```swift
    /// let color: Color = .red
    /// await setParameter(named: "Color", value: .color(color), for: entity, atSubsetIndex: 0)
    /// ```
    static func setParameter(
        named name: String,
        value: MaterialParameters.Value,
        for entity: RealityKit.Entity?,
        atSubsetIndex geoSubsetIndex: Array.Index
    ) async throws {
        guard
            let material = await entity?.shaderGraphMaterial(at: geoSubsetIndex),
            material.hasMaterialParameter(named: name)
        else { return }
        
        try await entity?.update(shaderGraphMaterial: material, geoSubsetIndex: geoSubsetIndex) { mat in
            try mat.setParameter(name: name, value: value)
        }
    }
}
