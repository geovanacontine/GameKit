import Foundation

extension CGRect: Equatable {
    public static func == (lhs: CGRect, rhs: CGRect) -> Bool {
        lhs.size == rhs.size && lhs.origin == rhs.origin
    }
}

public extension CGRect {
    func vertices() -> (minX: Double, maxX: Double, minY: Double, maxY: Double) {
        let minX = origin.x
        let maxX = size.width + origin.x
        let minY = origin.y
        let maxY = size.width + origin.y
        return (minX, maxX, minY, maxY)
    }
    
    func intersects(_ rect: CGRect) -> Bool {
        let ownVertices = self.vertices()
        let rectVertices = rect.vertices()
        
        let xRange = rectVertices.minX...rectVertices.maxX
        let isInXRange = xRange.contains(ownVertices.minX) || xRange.contains(ownVertices.maxX)
        
        let yRange = rectVertices.minY...rectVertices.maxY
        let isInYRange = yRange.contains(ownVertices.minY) || yRange.contains(ownVertices.maxY)
        
        return isInXRange && isInYRange
    }
    
    func offset(x: Double, y: Double) -> CGRect {
        .init(
            origin: .init(x: origin.x + x, y: origin.y + y),
            size: .init(width: size.width, height: size.height)
        )
    }
    
    func scaled(by scale: Double) -> CGRect {
        .init(origin: origin, size: .init(width: size.width * scale, height: size.height * scale))
    }
}

extension CGPoint: Equatable {
    public static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension CGSize: Equatable {
    public static func == (lhs: CGSize, rhs: CGSize) -> Bool {
        lhs.width == rhs.width && lhs.height == rhs.height
    }
}
