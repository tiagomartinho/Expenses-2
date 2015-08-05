import RealmSwift
import Foundation

public class RealmUtilities {
    public static func deleteAllEntries(){
        let realm = Realm()
        realm.beginWrite()
        realm.deleteAll()
        realm.commitWrite()
    }
    
    public static func createEntries(expenses:Results<Expense>){
        for expense in expenses {
            RealmUtilities.createEntryWithAmount(expense.amount, PaidBy: expense.paidBy, PaidTo: expense.paidTo, AtDate: expense.date, WithCategory: expense.category)
        }
    }
    
    public static func createEntryWithAmount(amount:Double,PaidBy by:Int=0,PaidTo to:Int=2,AtDate date:NSDate=NSDate(),WithCategory category:String=""){
        let realm = Realm()
        realm.beginWrite()
        realm.create(Expense.self, value: [NSUUID().UUIDString, amount, by, to, category,date])
        realm.commitWrite()
    }
    
    public static func updateEntries(expenses:Results<Expense>){
        for expense in expenses {
            updateEntry(expense)
        }
    }
    
    public static func updateEntry(entry: Expense){
        let realm = Realm()
        realm.beginWrite()
        realm.create(Expense.self, value: entry, update: true)
        realm.commitWrite()
    }
    
    public static func deleteEntry(entry: Expense){
        let realm = Realm()
        realm.beginWrite()
        realm.delete(entry)
        realm.commitWrite()
    }
    
    public static func deleteRealmFilesAtPath(path: String) {
        let fileManager = NSFileManager.defaultManager()
        fileManager.removeItemAtPath(path, error: nil)
        let lockPath = path + ".lock"
        fileManager.removeItemAtPath(lockPath, error: nil)
    }
}