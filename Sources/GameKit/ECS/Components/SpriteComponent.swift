import Foundation

public class SpriteComponent: Component {
    
    public var textureName: String
    public var width: Int
    public var height: Int
    
    public init(
        textureName: String,
        width: Int,
        height: Int
    ) {
        self.textureName = textureName
        self.width = width
        self.height = height
    }
}
