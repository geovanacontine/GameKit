import Foundation

public protocol RenderFramework {
    var isDebuggingPhysics: Bool { get set }
    func render(entity: Entity)
}

public struct RenderSystem: System {
    
    private let framework: RenderFramework
    
    public init(framework: RenderFramework) {
        self.framework = framework
    }
    
    public let requiredComponents: [Component.Type] = [
        SpriteComponent.self,
        TransformComponent.self
    ]
    
    public func update(context: GameSceneContext) {
        for entity in context.scene.queryEntities(componentTypes: requiredComponents) {
            framework.render(entity: entity)
        }
    }
}
