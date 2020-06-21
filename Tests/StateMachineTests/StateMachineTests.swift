import XCTest
@testable import StateMachine

final class StateMachineTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(StateMachine().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
