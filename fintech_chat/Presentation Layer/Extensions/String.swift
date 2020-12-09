import Foundation

extension String {
    var isBlank: Bool {
        return allSatisfy {
            $0.isWhitespace
        }
    }
}

extension Optional where Wrapped == String {
    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}
