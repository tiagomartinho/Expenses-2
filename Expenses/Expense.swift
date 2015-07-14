import RealmSwift

public class Expense: Object {
    dynamic var amount:Double = 0
    dynamic var paidBy = 0
    dynamic var paidTo = 0
    dynamic var category = ""
    dynamic var date = NSDate()
}