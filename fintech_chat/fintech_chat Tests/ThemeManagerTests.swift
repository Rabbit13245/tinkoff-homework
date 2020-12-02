@testable import Финтех_чат
import XCTest

class ThemeManagerTests: XCTestCase {

    func testThemeManager() throws {
        let themeForApply: AppTheme = .night
        ThemeManager.shared.applyTheme(themeForApply)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let savedTheme = AppTheme(rawValue: UserDefaults.standard.integer(forKey: "SelectedTheme")) ?? .classic
            
            XCTAssertEqual(ThemeManager.shared.theme, themeForApply)
            XCTAssertEqual(savedTheme, themeForApply)
        }
    }
}
