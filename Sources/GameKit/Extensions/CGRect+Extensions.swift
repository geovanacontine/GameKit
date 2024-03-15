import Foundation

extension CGRect: Equatable {
    public static func == (lhs: CGRect, rhs: CGRect) -> Bool {
        lhs.size == rhs.size && lhs.origin == rhs.origin
    }
}

public extension CGRect {
    func vertices() -> (x1: Double, x2: Double, y1: Double, y2: Double) {
        let x1 = origin.x
        let x2 = size.width + x1
        let y1 = origin.y
        let y2 = size.width + origin.y
        return (x1, x2, y1, y2)
    }
    
    func intersects(_ rect: CGRect) -> Bool {
        let ownVertices = self.vertices()
        let rectVertices = rect.vertices()
        
        let xRange = rectVertices.x1...rectVertices.x2
        let isInXRange = xRange.contains(ownVertices.x1) || xRange.contains(ownVertices.x2)
        
        let yRange = rectVertices.y1...rectVertices.y2
        let isInYRange = yRange.contains(ownVertices.y1) || yRange.contains(ownVertices.y2)
        
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
