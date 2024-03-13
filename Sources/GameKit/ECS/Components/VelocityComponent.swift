import Foundation

public class VelocityComponent: Component {
    
    public var maxSpeed: Double
    
    // Velocity
    public var x: Double = 0
    public var y: Double = 0
    
    public var isResting: Bool {
        x == 0 && y == 0
    }
    
    public init(maxSpeed: Double) {
        self.maxSpeed = maxSpeed
    }
}
