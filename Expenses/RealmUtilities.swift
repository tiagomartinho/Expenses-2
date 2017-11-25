import RealmSwift
import Foundation

open class RealmUtilities {
    open static func deleteAllEntries(){
        let realm = try! Realm()
        realm.beginWrite()
        realm.deleteAll()
        try! realm.commitWrite()
    }
    
    open static func createEntries(_ expenses:Results<Expense>){
        for expense in expenses {
            RealmUtilities.createEntryWithAmount(expense.amount, PaidBy: expense.paidBy, PaidTo: expense.paidTo, AtDate: expense.date, WithCategory: expense.category)
        }
    }
    
    open static func createEntryWithAmount(_ amount:Double,PaidBy by:Int=0,PaidTo to:Int=2,AtDate date:Date=Date(),WithCategory category:String=""){
        let realm = try! Realm()
        realm.beginWrite()
        realm.create(Expense.self, value: [UUID().UUIDString, amount, by, to, category,date])
        try! realm.commitWrite()
    }
    
    open static func updateEntries(_ expenses:Results<Expense>){
        for expense in expenses {
            updateEntry(expense)
        }
    }
    
    open static func updateEntry(_ entry: Expense){
        let realm = try! Realm()
        realm.beginWrite()
        realm.create(Expense.self, value: entry, update: true)
        try! realm.commitWrite()
    }
    
    open static func deleteEntry(_ entry: Expense){
        let realm = try! Realm()
        realm.beginWrite()
        realm.delete(entry)
        try! realm.commitWrite()
    }
    
    open static func deleteRealmFilesAtPath(_ path: String) {
        let fileManager = FileManager.default
        fileManager.removeItemAtPath(path, error: nil)
        let lockPath = path + ".lock"
        fileManager.removeItemAtPath(lockPath, error: nil)
    }
}
