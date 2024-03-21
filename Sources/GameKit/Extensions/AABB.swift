import Foundation

// Axis-Aligned Bounding Box
class AABB {
    
    let id: String
    let center: CGPoint
    let width: Double
    let height: Double
    
    var minX: Double { center.x - width/2 }
    var maxX: Double { center.x + width/2 }
    var minY: Double { center.y - height/2 }
    var maxY: Double { center.y + height/2 }
    
    init(center: CGPoint, width: Double, height: Double) {
        self.center = center
        self.width = width
        self.height = height
        self.id = UUID().uuidString
    }
    
    init?(entity: Entity) {
        guard let transform = entity[TransformComponent.self] else { return nil }
        guard let collider = entity[ColliderComponent.self] else { return nil }
        
        self.center = .init(x: transform.x, y: transform.y)
        self.width = collider.width
        self.height = collider.height
        self.id = entity.id
    }
    
    init(containing entities: [Entity]) {
        let aabbs = entities.compactMap({ AABB(entity: $0) })
        let minX = aabbs.map({ $0.minX }).min() ?? .zero
        let maxX = aabbs.map({ $0.maxX }).max() ?? .zero
        let minY = aabbs.map({ $0.minY }).min() ?? .zero
        let maxY = aabbs.map({ $0.maxY }).max() ?? .zero
        
        let width = maxX - minX
        let height = maxY - minY
        
        let centerX = minX + width/2
        let centerY = minY + height/2
        
        self.center = CGPoint(x: centerX, y: centerY)
        self.width = width
        self.height = height
        self.id = UUID().uuidString
    }
}

extension AABB {
    func intersects(_ aabb: AABB) -> Bool {
        let xRange = aabb.minX...aabb.maxX
        let isInXRange = xRange.contains(minX) || xRange.contains(maxX)
        
        let yRange = aabb.minY...aabb.maxY
        let isInYRange = yRange.contains(minY) || yRange.contains(maxY)
        
        return isInXRange && isInYRange
    }
    
    func offset(x: Double, y: Double) -> AABB {
        .init(
            center: .init(x: center.x + x, y: center.y + y),
            width: width,
            height: height
        )
    }
}
