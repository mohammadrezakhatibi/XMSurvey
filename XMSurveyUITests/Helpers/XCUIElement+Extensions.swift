import XCTest

extension XCUIElement {
    @discardableResult
    func assertExists(timeout: TimeInterval = 0, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForExistence(timeout: timeout), "Element \(self) doesn't exist.", file: file, line: line)
        return self
    }
}


extension XCUIElement {
    func type(_ text: String) {
        tap()
        typeText(text)
    }
    
    func clearText() {
        XCTContext.runActivity(named: "Clearing text in \(self)") { _ in
            guard let stringValue = value as? String else {
                XCTFail("Tried to clear and enter text into a non string value")
                return
            }

            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

            typeText(deleteString)
        }
    }
}
