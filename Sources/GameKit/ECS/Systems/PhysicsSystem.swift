import Foundation

public struct PhysicsSystem: System {
    
    public let requiredComponents: [Component.Type] = [
        ColliderComponent.self,
        TransformComponent.self,
        VelocityComponent.self
    ]
    
    public func update(context: GameSceneContext) {
        
        let boxes = context
            .scene
            .queryEntities(componentTypes: [ColliderComponent.self, TransformComponent.self])
            .map({ rect(forEntity: $0) })
        
        for entity in context.scene.queryEntities(componentTypes: requiredComponents) {
            let collider = entity[ColliderComponent.self]!
            let transform = entity[TransformComponent.self]!
            let velocity = entity[VelocityComponent.self]!

            let projectedX = transform.x + Int(velocity.x)
            let projectedY = transform.y + Int(velocity.y)
            
            let projectedRect = CGRect(
                x: projectedX,
                y: projectedY,
                width: collider.width,
                height: collider.height
            )
            
            let currentRect = rect(forEntity: entity)
            let otherBoxes = boxes.filter({ $0 != currentRect })
            
            let isFreeMovement = otherBoxes.allSatisfy({ !projectedRect.intersects($0) })
            
            if !isFreeMovement {
                velocity.x = 0
                velocity.y = 0
            }
        }
    }
    
    private func rect(forEntity entity: Entity) -> CGRect {
        let collider = entity[ColliderComponent.self]!
        let transform = entity[TransformComponent.self]!
        
        return .init(
            x: transform.x,
            y: transform.y,
            width: collider.width,
            height: collider.height
        )
    }
}
