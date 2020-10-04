import Foundation

extension Date{
    func year() -> Int{
        return Calendar.current.dateComponents([.year], from: self).year ?? 0
    }
    
    func month() -> Int{
        return Calendar.current.dateComponents([.month], from: self).month ?? 0
    }
    
    func day() -> Int{
        return Calendar.current.dateComponents([.day], from: self).day ?? 0
    }
}
