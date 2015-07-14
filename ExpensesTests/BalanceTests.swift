import XCTest
import RealmSwift
import ExpensesBy2

class BalanceTests: XCTestCase {
    
    // MARK: Constants
    let value = 12.34
    let person1Name = defaults.objectForKey(kUD_Person1) as? String ?? "1"
    let person2Name = defaults.objectForKey(kUD_Person2) as? String ?? "2"
    
    // MARK: SetUp
    override func setUp() {
        RealmUtilities.deleteAllEntries()
    }
    
    // MARK: Total Tests
    func testTotalForEmptyEntries() {
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testTotalOneEntryForPerson1() {
        RealmUtilities.addEntryWithAmount(value)
        XCTAssertEqual(value/2, Balance.total())
    }
    
    func testTwoEntriesGivesSumAmountBalance() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value)
        XCTAssertEqual((value+value)/2, Balance.total())
    }
    
    func testTwoEqualEntriesFromDifferentPersonsGivesZeroBalance() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value,paidBy:1)
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testSomeEntriesFromDifferentPersonsGivesCorrectBalance() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value,paidBy:1)
        XCTAssertEqual(value/2, Balance.total())
        RealmUtilities.addEntryWithAmount(value,paidBy:1)
        XCTAssertEqual(0.0, Balance.total())
        RealmUtilities.addEntryWithAmount(value,paidBy:1)
        XCTAssertEqual(-value/2, Balance.total())
    }
    
    // MARK: Summary Tests
    func testSummaryForEmptyEntries(){
        XCTAssertEqual("zero_balance".localized, Balance.summary())
    }
    
    func testSummaryOneEntryForPerson1() {
        RealmUtilities.addEntryWithAmount(value)
        let summary = person2Name + " owes " + person1Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
    }
    
    func testTwoEntriesGivesSummary() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value)
        let summary = person2Name + " owes " + person1Name + " " + "\((value+value)/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
    }
    
    func testTwoEqualEntriesFromDifferentPersonsGivesSummary() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value,paidBy:1)
        XCTAssertEqual("zero_balance".localized, Balance.summary())
    }
    
    func testSomeEntriesFromDifferentPersonsGivesSummary() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value,paidBy:1)
        var summary = person2Name + " owes " + person1Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
        RealmUtilities.addEntryWithAmount(value,paidBy:1)
        XCTAssertEqual("zero_balance".localized, Balance.summary())
        RealmUtilities.addEntryWithAmount(value,paidBy:1)
        summary = person1Name + " owes " + person2Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
    }
    
    // MARK: Totals Formatted Tests
    func testBalanceTotalFormatted(){
        XCTAssertEqual("0.00€", Balance.absoluteTotalFormatted())
        RealmUtilities.addEntryWithAmount(2.0)
        XCTAssertEqual("1.00€", Balance.absoluteTotalFormatted())
    }
}