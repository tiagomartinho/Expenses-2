import XCTest
import RealmSwift
import Expenses_2

class BalanceTests: XCTestCase {

    func testEmptyRealmGivesZeroBalance() {
        deleteAllEntries()
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testOneEntryGivesSameAmountBalance() {
        let value = 12.34
        deleteAllEntries()
        addEntry(value)
        XCTAssertEqual(value, Balance.total())
    }
    
    func deleteAllEntries(){
        let realm = Realm()
        realm.beginWrite()
        realm.deleteAll()
        realm.commitWrite()
    }
    
    func addEntry(amount:Double,personIndex:Int=0){
        let date = NSDate()
        let realm = Realm()
        realm.beginWrite()
        realm.create(Expense.self, value: [personIndex,amount,"",date])
        realm.commitWrite()
    }
}