@testable import Финтех_чат
import FBSnapshotTestCase
import XCTest

class ProfileViewUITests: XCTestCase {

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Открываем экран профиля
        app.buttons["OpenProfileVC"].tap()
        
        let textViewsCount = app.textViews.count
        
        XCTAssertEqual(textViewsCount, 2)
    }
}
