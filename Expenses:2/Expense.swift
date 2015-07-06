import RealmSwift

class Expense: Object {
    dynamic var amount = 0
    dynamic var category = ""
    dynamic var person = ""
    dynamic var date = NSDate()
    
    static func isAmountValid(amount:String?) -> Bool {
        if let amount = amount?.amount {
            return true
        }
        else {
            return false
        }
    }
}