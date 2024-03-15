import Foundation

open class Entity {
    public let id: String = UUID().uuidString
    private(set) var components: [String: Component] = [:]
    public init() {}
}

public extension Entity {
    func addComponent<T: Component>(_ component: T) {
        guard !hasComponent(withId: T.id) else { return }
        components.updateValue(component, forKey: T.id)
    }
    
    func removeComponent(withId component: String) {
        components.removeValue(forKey: component)
    }
    
    func hasComponent(withId component: String) -> Bool {
        components[component] != nil
    }
    
    func hasComponents(withIds components: [String]) -> Bool {
        components.allSatisfy({ hasComponent(withId: $0) })
    }
}

extension Entity: Equatable {
    public static func == (lhs: Entity, rhs: Entity) -> Bool { lhs.id == rhs.id }
}

public extension Entity {
    subscript<T: Component>(_ component: T.Type) -> T? {
        components[component.id] as? T
    }
}
