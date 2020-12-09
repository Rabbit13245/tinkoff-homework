@testable import Финтех_чат
import XCTest

class ProfileViewUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }
    
    func testProfileVC() throws {
        let app = XCUIApplication()
        app.launch()

        // Открываем экран профиля
        app.buttons["OpenProfileVC"].tap()

        let textViewsCount = app.textViews.count

        XCTAssertEqual(textViewsCount, 2)
    }
}
