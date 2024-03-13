import Foundation

open class Entity {
    public let id: String = UUID().uuidString
    private(set) var components: [Component] = []
    public init() {}
}

public extension Entity {
    func addComponent(_ component: Component) {
        guard !hasComponent(ofType: component.innerType) else { return }
        components.append(component)
    }
    
    func removeComponent(ofType componentType: Component.Type) {
        components.removeAll(where: { $0.innerType == componentType })
    }
    
    func getComponent<T: Component>(ofType componentType: T.Type) -> T? {
        components.first(where: { $0.innerType == componentType }) as? T
    }
    
    func hasComponent(ofType componentType: Component.Type) -> Bool {
        self[componentType] != nil
    }
    
    func hasComponents(ofTypes componentTypes: [Component.Type]) -> Bool {
        componentTypes.allSatisfy({ hasComponent(ofType: $0) })
    }
}

extension Entity: Equatable {
    public static func == (lhs: Entity, rhs: Entity) -> Bool { lhs.id == rhs.id }
}

public extension Entity {
    subscript<T: Component>(_ componentType: T.Type) -> T? {
        components.first(where: { $0.innerType == componentType }) as? T
    }
}
