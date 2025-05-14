import SwiftUI
import RealityKit

/// A respresentation of an attribute associated with an Entity as a SwiftUI `View`.
///
/// - parameter entity: The underlying RealityKit `Enitiy`
/// - parameter name: The name of the attribute
/// - parameter value: The wrapped value of the attribute
public protocol EntityAttribute: View, Identifiable {
    associatedtype Value: Hashable
    
    var entity: RealityKit.Entity? { get set }
    var name: String { get }
    var value: Value { get nonmutating set }
}

extension EntityAttribute {
    var projectedValue: Binding<Value> {
        .init(get: { value }, set: { value = $0 })
    }
    
    func with(entity: RealityKit.Entity) -> Self {
        var copy = self
        copy.entity = entity
        return copy
    }
}

extension EntityAttribute {
    public var id: String { String(describing: self) }
}

/// A type-erased version of `EntityAttribute` for 
struct AnyEntityAttribute: EntityAttribute {
    var entity: RealityKit.Entity?
    var name: String
    
    private var _get: () -> AnyHashable
    private var _set: (AnyHashable) -> Void
    
    var value: AnyHashable {
        get { _get() }
        nonmutating set { _set(newValue) }
    }
    
    private var _body: () -> AnyView
    var body: some View {
        // use copy not original
        _body()
    }
    // Take out name and entity, don't set here
    init<T: EntityAttribute>(_ attribute: T) {
        _get = { attribute.value }
        _set = { attribute.value = $0 as! T.Value }
        _body = { .init(attribute.body) }
        entity = attribute.entity
        name = attribute.name
    }
}

public extension Library {
    static func getParameter<T>(named name: String, for entity: RealityKit.Entity?, at geoSubsetIndex: Int) -> T? {
        guard
            let material = entity?.shaderGraphMaterial(at: geoSubsetIndex),
            material.hasMaterialParameter(named: name)
        else { return nil }
        
        guard case .color(let value) = material.getParameter(name: name) else { return nil }
        return value as? T
    }
    static func setParameter(named name: String, value: MaterialParameters.Value, for entity: RealityKit.Entity?, at geoSubsetIndex: Int) throws {
        guard
            let material = entity?.shaderGraphMaterial(at: geoSubsetIndex),
            material.hasMaterialParameter(named: name)
        else { return }
        
        try entity?.update(shaderGraphMaterial: material, geoSubsetIndex: geoSubsetIndex) { mat in
            try mat.setParameter(name: name, value: value)
        }
    }
}

public extension Library {
    struct Color: EntityAttribute {
        
        public var entity: RealityKit.Entity?
        public var name: String = ""
        public var geoSubsetIndex: Int
        
        public init(entity: RealityKit.Entity? = nil, name: String = "", geoSubsetIndex: Int = 0) {
            self.entity = entity
            self.name = name
            self.geoSubsetIndex = geoSubsetIndex
        }
        
        private let parameterName = "Color"
        
        public var value: SwiftUI.Color {
            get {
                guard let color: CGColor = getParameter(named: parameterName, for: entity, at: geoSubsetIndex)
                else { return .primary }
                return SwiftUI.Color(cgColor: color)
            }
            nonmutating set {
                try! setParameter(named: parameterName, value: .color(UIColor(newValue)), for: entity, at: geoSubsetIndex)
            }
        }
        
        public var body: some View {
            ColorPicker(name, selection: projectedValue)
        }
    }
}
