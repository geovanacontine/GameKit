import Foundation

public struct PhysicsSystem: System {
    
    public let requiredComponents: [Component.Type] = [
        ColliderComponent.self,
        TransformComponent.self,
        VelocityComponent.self
    ]
    
    private let detectionRange = 2.0
    
    public func update(context: GameSceneContext) {
        let movableEntities = context.scene.queryEntities(byComponents: requiredComponents)
        let movingEntities = movableEntities.filter({ $0[VelocityComponent.self]?.isResting == false })
        
        let allBoxes = context
            .scene
            .allEntities()
        
        for entity in movingEntities {
            let velocity = entity[VelocityComponent.self]!

            let currentRect = rect(forEntity: entity)
            let projectedRect = currentRect.offset(x: velocity.x, y: velocity.y)
            let detectionRect = projectedRect.scaled(by: detectionRange)
            
            let boxesInRange = allBoxes
                .map({ rect(forEntity: $0) })
                .filter({ $0.intersects(detectionRect) })
            
            let otherBoxes = boxesInRange.filter({ $0 != currentRect })
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
            origin: .init(x: Double(transform.x), y: Double(transform.y)),
            size: .init(width: Double(collider.width), height: Double(collider.height))
        )
    }
}
