import Foundation

open class GameScene {
    
    // Structure
    private var systems: [System]
    private var entities: [Entity] = []
    private let render: RenderProtocol
    
    // Update
    private let startTime: TimeInterval
    private var lastUpdate: TimeInterval
    
    // Frame rate
    private let frameRate = 60.0
    private var frameTimer: Timer?
    
    // Analytics
    private var analytics: [SystemAnalytics] = []
    private var analyticsTimer: Timer?
    
    public init(render: RenderProtocol) {
        systems = []
        entities = []
        self.render = render
        startTime = Date().timeIntervalSince1970
        lastUpdate = startTime
        setupSystems()
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
            SpawnSystem(),
            InputSystem(),
            PhysicsSystem(),
            MovementSystem(),
            RenderSystem()
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
    
    func queryEntities(byComponents components: [Component.Type]) -> [Entity] {
        let ids = components.map({ $0.id })
        return entities.filter({ $0.hasComponents(withIds: ids) })
    }
    
    func allEntities() -> [Entity] {
        entities
    }
}

// MARK: - Game Actions

public extension GameScene {
    func pause() {
        frameTimer?.invalidate()
        analyticsTimer?.invalidate()
    }
    
    func resume() {
        setUpdateLoop()
    }
}

// MARK: - Update

private extension GameScene {
    func setUpdateLoop() {
        frameTimer = Timer.scheduledTimer(withTimeInterval: 1/frameRate, repeats: true) { [weak self] timer in
            self?.update()
        }
        
        analyticsTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.consolidateAnalytics()
        }
    }
    
    func update() {
        let now = Date().timeIntervalSince1970
        let deltaTime = now - lastUpdate
        lastUpdate = now
        
        let context = GameSceneContext(scene: self, deltaTime: deltaTime, render: render)
        
        for system in systems {
            let systemType = type(of: system)
            let start = Date().timeIntervalSince1970
            
            system.update(context: context)
            
            let systemAnalytics = SystemAnalytics(
                system: systemType,
                updateStart: start,
                updateEnd: Date().timeIntervalSince1970
            )
            
            analytics.append(systemAnalytics)
        }
    }
    
    func consolidateAnalytics() {
        let analyticsResult = systems.map { system in
            let systemType = type(of: system)
            let systemAnalytics = analytics.filter({ $0.system == systemType })
            let updateTime = systemAnalytics.map({ $0.updateDuration }).reduce(0, +)
            return (type: systemType, time: updateTime)
        }
        
        let totalTime = analyticsResult.map({ $0.time }).reduce(0, +)
        
        print("----------------------------------")
        print("Total: \( String(format: "%.2f", totalTime))s")
        print("")
        
        for analytics in analyticsResult {
            let percent = (analytics.time / totalTime) * 100
            let percentString = String(format: "%.2f", percent)
            print("[\(String(describing: analytics.type))] - \(percentString)%")
        }
        
        print("----------------------------------")
        
        analytics = []
        print("\n\n\n")
        
        
    }
}
