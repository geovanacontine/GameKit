import Foundation

public protocol RenderProtocol {
    var isDebuggingPhysics: Bool { get set }
    
    func spawn(entity: Entity)
    func update(entity: Entity)
    func destroy(entity: Entity)
}
