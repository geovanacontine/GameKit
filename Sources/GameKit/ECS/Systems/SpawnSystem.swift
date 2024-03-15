import Foundation

public struct SpawnSystem: System {
    
    public let requiredComponents: [Component.Type] = [
        SpawnComponent.self
    ]
    
    public func update(context: GameSceneContext) {
        for entity in context.scene.queryEntities(byComponents: requiredComponents) {
            context.render.spawn(entity: entity)
            entity.removeComponent(withId: SpawnComponent.id)
        }
    }
}
