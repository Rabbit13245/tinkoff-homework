@testable import Финтех_чат
import XCTest

class ThemeManagerTests: XCTestCase {

    func testThemeManager() throws {
        // given
        let themeForApply: AppTheme = .night
        
        // when
        ThemeManager.shared.applyTheme(themeForApply)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let savedTheme = AppTheme(rawValue: UserDefaults.standard.integer(forKey: "SelectedTheme")) ?? .classic
            
            XCTAssertEqual(ThemeManager.shared.theme, themeForApply)
            XCTAssertEqual(savedTheme, themeForApply)
        }
    }
}
