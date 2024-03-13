import Foundation

public class InputManager {
    
    public static let shared = InputManager()
    private init() {}
    
    private(set) var currentDevice: InputDevice = .keyboard
    
    private(set) var xAxis: Double = 0
    private(set) var yAxis: Double = 0
}

// MARK: - API

public extension InputManager {
    func changeInputDevice(to newInputDevice: InputDevice) {
        currentDevice = newInputDevice
    }
    
    func update(_ element: InputElement, value: Double) {
        switch element {
        case .xAxis: xAxis = value
        case .yAxis: yAxis = value
        }
    }
}
