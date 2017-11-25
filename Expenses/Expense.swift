import RealmSwift

open class Expense: Object {
    @objc dynamic var id = ""
    @objc dynamic var amount:Double = 0
    @objc dynamic var paidBy = 0
    @objc dynamic var paidTo = 0
    @objc dynamic var category = ""
    @objc dynamic var date = NSDate()
    
    override open static func primaryKey() -> String? {
        return "id"
    }
}
