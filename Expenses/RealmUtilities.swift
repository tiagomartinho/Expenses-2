import RealmSwift

public class RealmUtilities {
    public static func deleteAllEntries(){
        let realm = Realm()
        realm.beginWrite()
        realm.deleteAll()
        realm.commitWrite()
    }
    
    public static func addEntry(amount:Double,personIndex:Int=0,category:String=""){
        let date = NSDate()
        let realm = Realm()
        realm.beginWrite()
        realm.create(Expense.self, value: [personIndex,amount,category,date])
        realm.commitWrite()
    }
    
    public static func deleteEntry(entry: Expense){
        let realm = Realm()
        realm.beginWrite()
        realm.delete(entry)
        realm.commitWrite()
    }
}
