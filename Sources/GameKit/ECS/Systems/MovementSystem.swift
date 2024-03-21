import Foundation

public struct MovementSystem: System {
    
    public let requiredComponents: [Component.Type] = [
        VelocityComponent.self,
        TransformComponent.self
    ]
    
    public func update(context: GameSceneContext) {
        for entity in context.scene.queryEntities(byComponents: requiredComponents) {
            guard let transform = entity[TransformComponent.self] else { return }
            guard let velocity = entity[VelocityComponent.self] else { return }

            transform.x += velocity.x
            transform.y += velocity.y
        }
    }
}
