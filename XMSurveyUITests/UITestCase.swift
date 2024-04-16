import XCTest

class UITestCase: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false
        
        XCUIDevice.shared.orientation = .portrait
    }
    
    override func tearDown() {
        
        super.tearDown()
        app = nil
    }
    
    final func launchApp(launchArguments: [String] = []) {
        XCTContext.runActivity(named: "App launching.") { _ in
            app.launchArguments = ["–uitesting"]
            app.launchArguments.append(contentsOf: launchArguments)
            app.launch()
        }
    }
    
    final func screenshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
