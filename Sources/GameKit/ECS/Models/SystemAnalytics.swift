import Foundation

struct SystemAnalytics {
    let system: System.Type
    let updateStart: TimeInterval
    let updateEnd: TimeInterval
    
    var updateDuration: Double {
        updateEnd - updateStart
    }
}
