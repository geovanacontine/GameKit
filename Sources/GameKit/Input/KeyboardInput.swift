import Foundation

enum KeyboardKey: UInt16 {
    case a = 0
    case s = 1
    case d = 2
    case w = 13
}

public extension InputManager {
    func keyDown(_ code: UInt16) { handleKeyboardInput(keyCode: code, isPressed: true) }
    func keyUp(_ code: UInt16) { handleKeyboardInput(keyCode: code, isPressed: false) }
    
    func handleKeyboardInput(keyCode: UInt16, isPressed: Bool) {
        guard currentDevice == .keyboard else { return }
        guard let mappedKey = KeyboardKey(rawValue: keyCode) else { return }
        
        switch mappedKey {
        case .a: update(.xAxis, value: isPressed ? -1 : 0)
        case .s: update(.yAxis, value: isPressed ? -1 : 0)
        case .d: update(.xAxis, value: isPressed ? 1 : 0)
        case .w: update(.yAxis, value: isPressed ? 1 : 0)
        }
    }
}
