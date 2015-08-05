import XCTest
import RealmSwift
import ExpensesBy2

class RealmUtilitiesTests: XCTestCase {
    // MARK: SetUp and TearDown
    let realmPathForTesting = Realm().path + ".testing"
    
    override func setUp() {
        super.setUp()
        RealmUtilities.deleteRealmFilesAtPath(realmPathForTesting)
        Realm.defaultPath = realmPathForTesting
    }
    
    override func tearDown() {
        super.tearDown()
        RealmUtilities.deleteRealmFilesAtPath(realmPathForTesting)
    }
}
