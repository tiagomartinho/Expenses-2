import Foundation

extension String {
    var amount: Double? {
        var formatter = NSNumberFormatter()
        formatter.decimalSeparator = ","
        return formatter.numberFromString(self)?.doubleValue
    }
}