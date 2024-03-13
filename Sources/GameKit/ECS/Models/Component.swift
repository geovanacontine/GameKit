import Foundation

public protocol Component {}

extension Component {
    var innerType: Component.Type { type(of: self) }
}
