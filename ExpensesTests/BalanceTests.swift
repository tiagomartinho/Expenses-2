import XCTest
import RealmSwift
import Expenses_2

class BalanceTests: XCTestCase {
    
    // MARK: Constants
    let value = 12.34
    let person1Name = defaults.objectForKey(kUD_Person1) as? String ?? "1"
    let person2Name = defaults.objectForKey(kUD_Person2) as? String ?? "2"
    
    // MARK: Utilities
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
    
    // MARK: SetUp
    override func setUp() {
        deleteAllEntries()
    }
    
    // MARK: Total Tests
    func testTotalForEmptyEntries() {
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testTotalOneEntryForPerson1() {
        addEntry(value)
        XCTAssertEqual(value/2, Balance.total())
    }
    
    func testTwoEntriesGivesSumAmountBalance() {
        addEntry(value)
        addEntry(value)
        XCTAssertEqual((value+value)/2, Balance.total())
    }
    
    func testTwoEqualEntriesFromDifferentPersonsGivesZeroBalance() {
        addEntry(value)
        addEntry(value,personIndex:1)
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testSomeEntriesFromDifferentPersonsGivesCorrectBalance() {
        addEntry(value)
        addEntry(value)
        addEntry(value,personIndex:1)
        XCTAssertEqual(value/2, Balance.total())
        addEntry(value,personIndex:1)
        XCTAssertEqual(0.0, Balance.total())
        addEntry(value,personIndex:1)
        XCTAssertEqual(-value/2, Balance.total())
    }
    
    // MARK: Summary Tests
    func testSummaryForEmptyEntries(){
        XCTAssertEqual("zero_balance".localized, Balance.summary())
    }
    
    func testSummaryOneEntryForPerson1() {
        addEntry(value)
        let summary = person2Name + " owes " + person1Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
    }
    
    func testTwoEntriesGivesSummary() {
        addEntry(value)
        addEntry(value)
        let summary = person2Name + " owes " + person1Name + " " + "\((value+value)/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
    }
    
    func testTwoEqualEntriesFromDifferentPersonsGivesSummary() {
        addEntry(value)
        addEntry(value,personIndex:1)
        XCTAssertEqual("zero_balance".localized, Balance.summary())
    }
    
    func testSomeEntriesFromDifferentPersonsGivesSummary() {
        addEntry(value)
        addEntry(value)
        addEntry(value,personIndex:1)
        var summary = person2Name + " owes " + person1Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
        addEntry(value,personIndex:1)
        XCTAssertEqual("zero_balance".localized, Balance.summary())
        addEntry(value,personIndex:1)
        summary = person1Name + " owes " + person2Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
    }
}