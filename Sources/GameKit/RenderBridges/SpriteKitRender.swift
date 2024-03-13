import SpriteKit

public class SpriteKitRender: SKScene, RenderFramework {
    
    public var isDebuggingPhysics = false
    
    public override init() {
        super.init(size: .init(width: 1024, height: 768))
        scaleMode = .aspectFit
        anchorPoint = .init(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func render(entity: Entity) {
        if let entityNode = childNode(withName: entity.id) {
            update(node: entityNode, forEntity: entity)
        } else {
            createNode(forEntity: entity)
        }
    }
    
    private func createNode(forEntity entity: Entity) {
        guard let sprite = entity[SpriteComponent.self] else { return }
        
        let texture = SKTexture(imageNamed: sprite.textureName)
        let size = CGSize(width: sprite.width, height: sprite.height)
        let node = SKSpriteNode(texture: texture, size: size)
        node.name = entity.id
        addChild(node)
        
        if isDebuggingPhysics, let collider = entity[ColliderComponent.self] {
            let colliderNode = SKShapeNode(rectOf: .init(width: collider.width, height: collider.height))
            colliderNode.fillColor = .clear
            colliderNode.strokeColor = .orange
            node.addChild(colliderNode)
        }
        
        update(node: node, forEntity: entity)
    }
    
    private func update(node: SKNode, forEntity entity: Entity) {
        guard let position = entity[TransformComponent.self] else { return }
        
        let newPoint = CGPoint(x: position.x, y: position.y)
        let action = SKAction.move(to: newPoint, duration: 0.1)
        node.run(action)
    }
    
    // Input events
    public override func keyDown(with event: NSEvent) { InputManager.shared.keyDown(event.keyCode) }
    public override func keyUp(with event: NSEvent) { InputManager.shared.keyUp(event.keyCode) }
}
