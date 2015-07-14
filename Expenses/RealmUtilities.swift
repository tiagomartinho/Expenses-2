import RealmSwift

public class RealmUtilities {
    public static func deleteAllEntries(){
        let realm = Realm()
        realm.beginWrite()
        realm.deleteAll()
        realm.commitWrite()
    }
    
    public static func addEntryWithAmount(amount:Double,PaidBy by:Int=0,PaidTo to:Int=2,AtDate date:NSDate=NSDate(),WithCategory category:String=""){
        let realm = Realm()
        realm.beginWrite()
        realm.create(Expense.self, value: [amount, by, to, category,date])
        realm.commitWrite()
    }
    
    public static func deleteEntry(entry: Expense){
        let realm = Realm()
        realm.beginWrite()
        realm.delete(entry)
        realm.commitWrite()
    }
}
