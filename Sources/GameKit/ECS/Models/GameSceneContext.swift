import Foundation

public struct GameSceneContext {
    let scene: GameScene
    let deltaTime: TimeInterval
    let render: RenderProtocol
}
