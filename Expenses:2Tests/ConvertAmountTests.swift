import XCTest

class ConvertAmountTests: XCTestCase {
    func testZero() {
        XCTAssertEqual("0".amount!, 0.0)
    }
    
    func testValidInputs() {
        XCTAssertEqual("1,".amount!, 1.0)
        XCTAssertEqual("1,3".amount!, 1.3)
        XCTAssertEqual("1,32".amount!, 1.32)
    }
}
