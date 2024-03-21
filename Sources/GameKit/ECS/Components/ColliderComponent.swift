import Foundation

public class ColliderComponent: Component {
    
    public var width: Double
    public var height: Double
    
    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
}
