import Foundation

extension String {
    var amount: Double? {
        let amount = self.removeWhitespaces()
        if let doubleValue = amount.doubleValueComma {
            return doubleValue
        }
        else {
            if let doubleValue = amount.doubleValueDot {
                return doubleValue
            }
            else {
                return nil
            }
        }
    }
    
    var doubleValueComma:Double?{
        var formatter = NSNumberFormatter()
        formatter.decimalSeparator = ","
        if let doubleValue = formatter.numberFromString(self)?.doubleValue {
            return Double(round(doubleValue*100)/100)
        }
        else {
            return nil
        }
    }
    
    var doubleValueDot:Double?{
        var formatter = NSNumberFormatter()
        formatter.decimalSeparator = "."
        if let doubleValue = formatter.numberFromString(self)?.doubleValue {
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