import RealmSwift

public class Expense: Object {
    dynamic var id = ""
    dynamic var amount:Double = 0
    dynamic var paidBy = 0
    dynamic var paidTo = 0
    dynamic var category = ""
    dynamic var date = NSDate()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}