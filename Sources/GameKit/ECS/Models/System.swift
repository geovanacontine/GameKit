import Foundation

public protocol System {
    var requiredComponents: [Component.Type] { get }
    func update(context: GameSceneContext)
}
