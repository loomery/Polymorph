import Polymorph

struct MockEntityRepresentable: EntityRepresentable {
    
    let name: String
    var entity: Entity
    var subEntities: [Polymorph.Library.Entity]
    
    init(named name: String = "Box", @EntityBuilder subEntities: () async -> [Library.Entity]) async throws {
        let boxMesh = await MeshResource.generateBox(size: 0.1)
        let mat = SimpleMaterial(color: .blue, isMetallic: false)
        let boxEntity = await ModelEntity(mesh: boxMesh, materials: [mat])
        
        self.name = name
        let entity = boxEntity
        
        self.subEntities = await subEntities().map {
            $0.withEntity(entity)
        }
        self.entity = boxEntity
    }
}
