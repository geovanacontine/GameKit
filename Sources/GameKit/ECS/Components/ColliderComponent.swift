import Foundation

public class ColliderComponent: Component {
    
    public var width: Int
    public var height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}
