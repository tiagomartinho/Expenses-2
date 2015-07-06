import Foundation

extension String {
    var amount: Double? {
        let amount = self.removeWhitespaces()
        var formatter = NSNumberFormatter()
        formatter.decimalSeparator = ","
        if let doubleValue = formatter.numberFromString(amount)?.doubleValue {
            return Double(round(doubleValue*100)/100)
        }
        else {
            return nil
        }
    }
    
    func removeWhitespaces()->String{
        return self.replace(" ",replacement:"")
    }
    
    func replace(replaced:String,replacement:String)->String{
        return self.stringByReplacingOccurrencesOfString(replaced, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}