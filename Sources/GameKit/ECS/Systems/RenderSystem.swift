import Foundation

public struct RenderSystem: System {
    
    public let requiredComponents: [Component.Type] = [
        SpriteComponent.self,
        TransformComponent.self,
        VelocityComponent.self
    ]
    
    public func update(context: GameSceneContext) {
        for entity in context.scene.queryEntities(byComponents: requiredComponents) {
            context.render.update(entity: entity)
        }
    }
}
