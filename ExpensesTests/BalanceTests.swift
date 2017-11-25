import XCTest
import RealmSwift
import ExpensesBy2

class BalanceTests: XCTestCase {
    
    // MARK: Constants
    let value = 12.34
    let person1Name = k.Person1Name
    let person2Name = k.Person2Name
    
    // MARK: SetUp and TearDown
    let realmPathForTesting = (try! Realm()).configuration.fileURL!.deletingLastPathComponent().path + ".testing"

    override func setUp() {
        super.setUp()
        RealmUtilities.deleteRealmFilesAtPath(realmPathForTesting)
        Realm.defaultPath = realmPathForTesting
    }
    
    override func tearDown() {
        super.tearDown()
        RealmUtilities.deleteRealmFilesAtPath(realmPathForTesting)
    }
    
    // MARK: Total Tests For In Common Expenses
    func testTotalForEmptyEntries() {
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testTotalOneEntryForPerson1() {
        RealmUtilities.createEntryWithAmount(value)
        XCTAssertEqual(value/2, Balance.total())
    }
    
    func testTwoEntriesGivesSumAmountBalance() {
        RealmUtilities.createEntryWithAmount(value)
        RealmUtilities.createEntryWithAmount(value)
        XCTAssertEqual((value+value)/2, Balance.total())
    }
    
    func testTwoEqualEntriesFromDifferentPersonsGivesZeroBalance() {
        RealmUtilities.createEntryWithAmount(value)
        RealmUtilities.createEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testSomeEntriesFromDifferentPersonsGivesCorrectBalance() {
        RealmUtilities.createEntryWithAmount(value)
        RealmUtilities.createEntryWithAmount(value)
        RealmUtilities.createEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual(value/2, Balance.total())
        RealmUtilities.createEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual(0.0, Balance.total())
        RealmUtilities.createEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual(-value/2, Balance.total())
    }
    
    // MARK: Total Tests For Not In Common Expenses
    func testTotalOneEntryForPerson1ToPerson2() {
        RealmUtilities.createEntryWithAmount(value, PaidBy: 0, PaidTo: 1)
        XCTAssertEqual(value, Balance.total())
    }
    
    func testTotalOneEntryForPerson2ToPerson1() {
        RealmUtilities.createEntryWithAmount(value, PaidBy: 1, PaidTo: 0)
        XCTAssertEqual(-value, Balance.total())
    }
    
    func testTotalOneEntryForPerson1ToPerson1() {
        RealmUtilities.createEntryWithAmount(value, PaidBy: 0, PaidTo: 0)
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testTotalOneEntryForPerson2ToPerson2() {
        RealmUtilities.createEntryWithAmount(value, PaidBy: 1, PaidTo: 1)
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testSomeEntriesFromDifferentPersonsBetweenThemselvesGivesCorrectBalance() {
        RealmUtilities.createEntryWithAmount(value, PaidBy: 0)
        RealmUtilities.createEntryWithAmount(value, PaidBy: 0, PaidTo: 0)
        RealmUtilities.createEntryWithAmount(value, PaidBy: 0, PaidTo: 1)
        XCTAssertEqual(value + value/2, Balance.total())
    }
    
    // MARK: Summary Tests
    func testSummaryForEmptyEntries(){
        XCTAssertEqual("zero_balance".localized, Balance.summaries[0])
        XCTAssertEqual(person1Name + " paid 0.00€", Balance.summaries[1])
        XCTAssertEqual(person2Name + " paid 0.00€", Balance.summaries[2])
        XCTAssertEqual(person1Name + " spent 0.00€", Balance.summaries[3])
        XCTAssertEqual(person2Name + " spent 0.00€", Balance.summaries[4])
    }
    
    func testSummaryOneEntryForPerson1() {
        RealmUtilities.createEntryWithAmount(value)
        let summary = person2Name + " owes " + person1Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summaries[0])
        XCTAssertEqual(person1Name + " paid \(value)€", Balance.summaries[1])
        XCTAssertEqual(person2Name + " paid 0.00€", Balance.summaries[2])
        XCTAssertEqual(person1Name + " spent \(value/2)€", Balance.summaries[3])
        XCTAssertEqual(person2Name + " spent \(value/2)€", Balance.summaries[4])
    }
    
    func testTwoEntriesGivesSummary() {
        RealmUtilities.createEntryWithAmount(value)
        RealmUtilities.createEntryWithAmount(value)
        let summary = person2Name + " owes " + person1Name + " " + "\((value+value)/2)" + "€"
        XCTAssertEqual(summary, Balance.summaries[0])
        XCTAssertEqual(person1Name + " paid \(value*2)€", Balance.summaries[1])
        XCTAssertEqual(person2Name + " paid 0.00€", Balance.summaries[2])
        XCTAssertEqual(person1Name + " spent \(value)€", Balance.summaries[3])
        XCTAssertEqual(person2Name + " spent \(value)€", Balance.summaries[4])
    }
    
    func testTwoEqualEntriesFromDifferentPersonsGivesSummary() {
        RealmUtilities.createEntryWithAmount(value)
        RealmUtilities.createEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual("zero_balance".localized, Balance.summaries[0])
        XCTAssertEqual(person1Name + " paid \(value)€", Balance.summaries[1])
        XCTAssertEqual(person2Name + " paid \(value)€", Balance.summaries[2])
        XCTAssertEqual(person1Name + " spent \(value)€", Balance.summaries[3])
        XCTAssertEqual(person2Name + " spent \(value)€", Balance.summaries[4])
    }
    
    func testSomeEntriesFromDifferentPersonsGivesSummary() {
        RealmUtilities.createEntryWithAmount(value)
        RealmUtilities.createEntryWithAmount(value)
        RealmUtilities.createEntryWithAmount(value,PaidBy:1)
        var summary = person2Name + " owes " + person1Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summaries[0])
        
        XCTAssertEqual(person1Name + " paid \(value*2)€", Balance.summaries[1])
        XCTAssertEqual(person2Name + " paid \(value)€", Balance.summaries[2])
        XCTAssertEqual(person1Name + " spent \(value*3/2)€", Balance.summaries[3])
        XCTAssertEqual(person2Name + " spent \(value*3/2)€", Balance.summaries[4])
        
        RealmUtilities.createEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual("zero_balance".localized, Balance.summaries[0])
        
        XCTAssertEqual(person1Name + " paid \(value*2)€", Balance.summaries[1])
        XCTAssertEqual(person2Name + " paid \(value*2)€", Balance.summaries[2])
        XCTAssertEqual(person1Name + " spent \(value*2)€", Balance.summaries[3])
        XCTAssertEqual(person2Name + " spent \(value*2)€", Balance.summaries[4])
        
        RealmUtilities.createEntryWithAmount(value,PaidBy:1)
        summary = person1Name + " owes " + person2Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summaries[0])
        
        XCTAssertEqual(person1Name + " paid \(value*2)€", Balance.summaries[1])
        XCTAssertEqual(person2Name + " paid \(value*3)€", Balance.summaries[2])
        XCTAssertEqual(person1Name + " spent \(value*5/2)€", Balance.summaries[3])
        XCTAssertEqual(person2Name + " spent \(value*5/2)€", Balance.summaries[4])
    }
    
    // MARK: Totals Formatted Tests
    func testBalanceTotalFormatted(){
        XCTAssertEqual("0.00€", Balance.total().currency)
        RealmUtilities.createEntryWithAmount(2.0)
        XCTAssertEqual("1.00€", Balance.total().currency)
    }
    
    // MARK: Person Totals
    func testPersonTotalOneEntryForPerson1() {
        RealmUtilities.createEntryWithAmount(value)
        XCTAssertEqual(value, Balance.totalPaidBy(0))
    }
    
    func testPersonTotalOneEntryForPerson2() {
        RealmUtilities.createEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual(value, Balance.totalPaidBy(1))
    }
}
