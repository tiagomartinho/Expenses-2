import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var amount: Double? {
        let amount = self.removeWhitespaces()
        if let doubleValue = amount.doubleValueComma {
            if doubleValue > 0 {
                return doubleValue
            }
        }
        if let doubleValue = amount.doubleValueDot {
            if doubleValue > 0 {
                return doubleValue
            }
        }
        return nil
    }
    
    var doubleValueComma:Double?{
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        if let doubleValue = formatter.number(from: self)?.doubleValue {
            return Double(round(doubleValue*100)/100)
        }
        else {
            return nil
        }
    }
    
    var doubleValueDot:Double?{
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        if let doubleValue = formatter.number(from: self)?.doubleValue {
            return Double(round(doubleValue*100)/100)
        }
        else {
            return nil
        }
    }
    
    func removeWhitespaces()->String{
        return self.replace(" ",replacement:"")
    }
    
    func replace(_ replaced:String,replacement:String)->String{
        return self.replacingOccurrences(of: replaced, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
}
