import RealityKit

/// A protocol for vending SwiftUI views that allow the underlying RealityKit `Entity` attributes such as materials customizable from your app's UI.
public protocol EntityRepresentable: Identifiable {
    var entity: RealityKit.Entity { get set }
    var subEntities: [Library.Entity] { get set }
}

extension EntityRepresentable {
    public var attributes: [some EntityAttribute] {
        subEntities.flatMap {
            $0.attributes.map { AnyEntityAttribute($0) }
        }
    }
    
    public var id: ObjectIdentifier { entity.id }
}
