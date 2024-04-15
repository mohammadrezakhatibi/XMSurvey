import Foundation
import HTTPClient

public enum SurveyEndPoints: String, EndPoint {
    case list = "/questions"
    case submit = "/question/submit"
}
