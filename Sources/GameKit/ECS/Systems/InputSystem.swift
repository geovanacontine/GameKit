import Foundation

public struct InputSystem: System {
    
    public let requiredComponents: [Component.Type] = [
        InputComponent.self,
        VelocityComponent.self
    ]
    
    public func update(context: GameSceneContext) {
        for entity in context.scene.queryEntities(componentTypes: requiredComponents) {
            guard let velocity = entity[VelocityComponent.self] else { return }

            velocity.x = InputManager.shared.xAxis * velocity.maxSpeed
            velocity.y = InputManager.shared.yAxis * velocity.maxSpeed
        }
    }
}
