import XCTest

class ConvertAmountTests: XCTestCase {
    func testZero() {
        XCTAssertEqual("0".amount!, 0.0)
    }
    
    func testValidInputs() {
        XCTAssertEqual("1,".amount!, 1.0)
        XCTAssertEqual("1,3".amount!, 1.3)
        XCTAssertEqual("1,32".amount!, 1.32)
        XCTAssertEqual("1,321453807".amount!, 1.32)
        XCTAssertEqual(" 1 , 3 ".amount!, 1.3)
    }
    
    func testInvalidInputs(){
        XCTAssertNil("1,32,1453807".amount)
        XCTAssertNil(",,,".amount)
        XCTAssertNil(",0,0,".amount)
        XCTAssertNil("".amount)
        XCTAssertNil(" ".amount)
        XCTAssertNil(" , ".amount)
    }
}
