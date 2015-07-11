import Foundation

extension Double {
    var currency: String {
        return String(format: "%.2f", abs(self)) + "currency".localized
    }
}