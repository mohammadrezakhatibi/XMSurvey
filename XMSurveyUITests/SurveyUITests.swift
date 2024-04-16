import XCTest

final class SurveyUITests: UITestCase {
    func test_pressStartButton_startSurvey() throws {
        launchSurvey()
        
        app.staticTexts["QuestionLabel"].firstMatch.assertExists(timeout: 2)
        app.textViews.firstMatch.assertExists()
        app.staticTexts["Questions 1/5"].firstMatch.assertExists(timeout: 2)
        
    }

    func test_pressNextPrevButton_navigateToNextPrevQuestion() throws {
        launchSurvey()
        
        app.staticTexts["QuestionLabel"].firstMatch.assertExists(timeout: 2)
        app.textViews.firstMatch.assertExists()
        app.staticTexts["Questions 1/5"].firstMatch.assertExists(timeout: 2)
        
        app.buttons["NextQuestionButton"].firstMatch.assertExists(timeout: 2).tap()
        app.staticTexts["Questions 2/5"].firstMatch.assertExists(timeout: 5)
        app.buttons["PreviousQuestionButton"].firstMatch.assertExists(timeout: 2).tap()
        
    }
    
    func test_startTyping_enableSubmitButton() throws {
        launchSurvey()
        
        app.textViews.firstMatch.type("Answer")
        XCTAssertTrue(app.buttons["SubmitButton"].firstMatch.assertExists(timeout: 2).isEnabled)
        
        app.textViews.firstMatch.clearText()
        XCTAssertFalse(app.buttons["SubmitButton"].firstMatch.assertExists(timeout: 2).isEnabled)
    }
    
    func test_startTyping_EnableSubmitButton2() {
        launchSurvey()
        
        app.textViews.firstMatch.type("Answer")
        app.buttons["SubmitButton"].firstMatch.assertExists(timeout: 2).tap()
        
        app.staticTexts["Questions Submitted: 1"].firstMatch.assertExists(timeout: 5)
        XCTAssertFalse(app.textViews.firstMatch.assertExists(timeout: 2).isEnabled)
        XCTAssertFalse(app.buttons["Already Submitted"].firstMatch.assertExists(timeout: 2).isEnabled)
    }
    
    func test_fail_showErrorView() {
        launchSurvey(launchArguments: ["failedSurvey"])
        
        app.otherElements["ErrorView"].firstMatch.assertExists(timeout: 2)
    }
    
    func test_failureSubmit_showFailureBanner() {
        launchSurvey(launchArguments: ["failedSubmit"])
        
        app.textViews.firstMatch.type("Answer")
        app.buttons["SubmitButton"].firstMatch.assertExists(timeout: 2).tap()
        
        app.otherElements["Banner-failure"].firstMatch.assertExists(timeout: 1)
    }
    
    func test_successSubmit_showSuccessBanner() {
        launchSurvey()
        
        app.textViews.firstMatch.type("Answer")
        app.buttons["SubmitButton"].firstMatch.assertExists(timeout: 2).tap()
        
        app.otherElements["Banner-success"].firstMatch.assertExists(timeout: 2)
    }
    
    private func launchSurvey(launchArguments: [String] = []) {
        launchApp(launchArguments: launchArguments)
        app.buttons["StartButton"].firstMatch.assertExists(timeout: 2).tap()
    }
}
