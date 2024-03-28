import RealityKit

/// A namespace for wrapping RealityKit's types.
public struct Library { }

public extension Library {
    struct Entity {
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
