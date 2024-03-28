import RealityKit

public extension Entity {
    var modelComponent: ModelComponent? {
        components[ModelComponent.self]
    }
    
    func shaderGraphMaterial(at index: Int) -> ShaderGraphMaterial? {
        guard
            let modelComponent,
            modelComponent.materials.count > index
        else { return nil }
        
        return modelComponent.materials[index] as? ShaderGraphMaterial
    }
    
    func update(shaderGraphMaterial oldMaterial: ShaderGraphMaterial,
                geoSubsetIndex: Int,
                _ handler: (inout ShaderGraphMaterial) throws -> Void) rethrows {
        var material = oldMaterial
        try handler(&material)
        
        if var component = modelComponent {
            component.materials[geoSubsetIndex] = material
            components.set(component)
        }
    }
}

public extension ShaderGraphMaterial {
    func hasMaterialParameter(named: String) -> Bool {
        parameterNames.contains(where: { $0 == named })
    }
}
