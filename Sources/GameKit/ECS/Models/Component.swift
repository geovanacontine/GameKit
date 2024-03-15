import Foundation

public protocol Component {}

extension Component {
    static var id: String { String(describing: type(of: self)) }
}
