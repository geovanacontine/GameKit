import Foundation

struct CollisionCheckLeaf {
    let entityA: Entity
    let entityB: Entity
}

// BoundaryVolumeHierarchy
class BVH {
    
    let root: BVHNode
    
    init(entities: [Entity], maxEntities: Int) {
        self.root = .init(entities: entities, maxEntities: maxEntities)
    }
    
    var allNodes: [BVHNode] {
        [root] + root.allChildren
    }
    
    var leaves: [BVHNode] {
        allNodes.filter({ $0.isLeaf })
    }
    
    var collisionCheckLeaves: [CollisionCheckLeaf] {
        let validLeaves = leaves.filter({ $0.entities.count == 2 })
        
        return validLeaves.map({
            CollisionCheckLeaf(
                entityA: $0.entities[0],
                entityB: $0.entities[1]
            )
        })
    }
}

class BVHNode {
    
    let aabb: AABB
    let maxEntities: Int
    
    var children: [BVHNode]
    var entities: [Entity]
    
    var isLeaf: Bool { children.isEmpty }
    var allChildren: [BVHNode] { children + children.flatMap({ $0.allChildren }) }
    
    init(entities: [Entity], maxEntities: Int) {
        self.aabb = .init(containing: entities)
        self.maxEntities = maxEntities
        self.entities = []
        self.children = []
        
        if entities.count > maxEntities {
            createChildren(entities: entities)
        } else {
            self.entities = entities
        }
    }
}

extension BVHNode {
    private func createChildren(entities: [Entity]) {
        let aabbs = entities.compactMap({ AABB(entity: $0) })
        let (firstHalf, lastHalf) = divideByLongestAxis(aabbs: aabbs)
        
        let firstHalfIds = firstHalf.map({ $0.id })
        let lastHalfIds = lastHalf.map({ $0.id })
        
        let firstHalfEntities = entities.filter({ firstHalfIds.contains($0.id) })
        let lastHalfEntities = entities.filter({ lastHalfIds.contains($0.id) })
        
        if !firstHalfEntities.isEmpty {
            let newNode = BVHNode(entities: firstHalfEntities, maxEntities: maxEntities)
            children.append(newNode)
        }
        
        if !lastHalfEntities.isEmpty {
            let newNode = BVHNode(entities: lastHalfEntities, maxEntities: maxEntities)
            children.append(newNode)
        }
    }
    
    private func divideByLongestAxis(aabbs: [AABB]) -> (firstHalf: [AABB], lastHalf: [AABB]) {
        if aabb.width >= aabb.height {
            let sorted = aabbs.sorted(by: { $0.center.x < $1.center.x })
            let firstHalf = sorted.filter({ $0.maxX < aabb.center.x })
            let lastHalf = sorted.filter({ $0.maxX >= aabb.center.x })
            return (firstHalf, lastHalf)
        } else {
            let sorted = aabbs.sorted(by: { $0.center.y < $1.center.y })
            let firstHalf = sorted.filter({ $0.maxY < aabb.center.y })
            let lastHalf = sorted.filter({ $0.maxY >= aabb.center.y })
            return (firstHalf, lastHalf)
        }
    }
}
