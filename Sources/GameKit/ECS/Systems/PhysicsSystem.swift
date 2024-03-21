import Foundation

public struct PhysicsSystem: System {
    
    public let requiredComponents: [Component.Type] = [
        ColliderComponent.self,
        TransformComponent.self,
        VelocityComponent.self
    ]
    
    public func update(context: GameSceneContext) {
        let entities = context.scene.allEntities()
        let bvh = BVH(entities: entities, maxEntities: 2)
        
        for collisionLeaf in bvh.collisionCheckLeaves {
            if isColliding(entityA: collisionLeaf.entityA, entityB: collisionLeaf.entityB) {
                constraintMovement(forEntity: collisionLeaf.entityA)
                constraintMovement(forEntity: collisionLeaf.entityB)
            }
        }
    }
    
    private func isColliding(entityA: Entity, entityB: Entity) -> Bool {
        guard let bodyA = AABB(entity: entityA), let bodyB = AABB(entity: entityB) else { return false }
        return bodyA.intersects(bodyB)
    }

    private func constraintMovement(forEntity entity: Entity) {
        guard let velocity = entity[VelocityComponent.self] else { return }
        velocity.x = 0
        velocity.y = 0
    }
}
