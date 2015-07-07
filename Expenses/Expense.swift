import RealmSwift

class Expense: Object {
    dynamic var personIndex = 0
    dynamic var amount:Double = 0
    dynamic var category = ""
    dynamic var date = NSDate()
}