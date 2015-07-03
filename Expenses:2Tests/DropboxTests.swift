import UIKit
import XCTest
import SwiftyDropbox

class DropboxTests: XCTestCase {
    
    let client = Dropbox.authorizedClient
    
    func testCurrentAccount(){
        let expectation = expectationWithDescription(nil)

        client!.usersGetCurrentAccount().response { response, error in
            if let account = response {
                XCTAssertEqual("t.martinho@live.com.pt", account.email)
                expectation.fulfill()
            } else {
                println(error!)
            }
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
        }
    }
}
