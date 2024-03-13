import Foundation

open class GameScene {
    
    // Structure
    private var systems: [System]
    private var entities: [Entity] = []
    
    // Update
    private let startTime: TimeInterval
    private var lastUpdate: TimeInterval
    
    // Frame rate
    private let frameRate = 60.0
    private var timer: Timer?
    
    public init(renderFramework: RenderFramework) {
        systems = []
        entities = []
        startTime = Date().timeIntervalSince1970
        lastUpdate = startTime
        setupSystems()
        
        let renderSystem = RenderSystem(framework: renderFramework)
        addSystem(renderSystem)
        
        setUpdateLoop()
        onStart()
    }
    
    // Events
    open func onStart() {}
}

// MARK: - Systems Actions

extension GameScene {
    public func addSystem(_ system: System) {
        systems.append(system)
    }
    
    private func setupSystems() {
        systems = [
            InputSystem(),
            PhysicsSystem(),
            MovementSystem()
        ]
    }
}

// MARK: - Entities Actions

public extension GameScene {
    func spawn(_ entity: Entity) {
        entities.append(entity)
    }
    
    func destroy(_ entity: Entity) {
        entities.removeAll(where: { $0 == entity })
    }
    
    func queryEntities(componentTypes: [Component.Type]) -> [Entity] {
        entities.filter({ $0.hasComponents(ofTypes: componentTypes) })
    }
}

// MARK: - Game Actions

public extension GameScene {
    func pause() {
        timer?.invalidate()
    }
    
    func resume() {
        setUpdateLoop()
    }
}

// MARK: - Update

private extension GameScene {
    func setUpdateLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: 1/frameRate, repeats: true) { [weak self] timer in
            self?.update()
        }
    }
    
    func update() {
        let now = Date().timeIntervalSince1970
        let deltaTime = now - lastUpdate
        lastUpdate = now
        
        let context = GameSceneContext(scene: self, deltaTime: deltaTime)
        
        for system in systems {
            system.update(context: context)
        }
    }
}
