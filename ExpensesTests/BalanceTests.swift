import XCTest
import RealmSwift
import Expenses_2

class BalanceTests: XCTestCase {

    let value = 12.34

    func testEmpty() {
        deleteAllEntries()
        XCTAssertEqual(0.0, Balance.total())
        XCTAssertEqual("zero_balance".localized, Balance.summary())
    }
    
    func testOneEntryGivesSameAmountBalance() {
        deleteAllEntries()
        addEntry(value)
        XCTAssertEqual(value, Balance.total())
    }
    
    func testTwoEntriesGivesSumAmountBalance() {
        deleteAllEntries()
        addEntry(value)
        addEntry(value)
        XCTAssertEqual(value+value, Balance.total())
    }
    
    func testTwoEqualEntriesFromDifferentPersonsGivesZeroBalance() {
        deleteAllEntries()
        addEntry(value)
        addEntry(value,personIndex:1)
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testSomeEntriesFromDifferentPersonsGivesCorrectBalance() {
        deleteAllEntries()
        addEntry(value)
        addEntry(value)
        addEntry(value,personIndex:1)
        XCTAssertEqual(value, Balance.total())
        addEntry(value,personIndex:1)
        XCTAssertEqual(0.0, Balance.total())
        addEntry(value,personIndex:1)
        XCTAssertEqual(-value, Balance.total())
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