import Foundation

private enum DateFormatterCache {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .short
        return formatter
    }()
    
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "E, d 'de' MMM"
        return formatter
    }()
    
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.timeStyle = .short
        return formatter
    }()
}

public extension Date {
    func formattedShortDate() -> String {
        return DateFormatterCache.shortDate.string(from: self)
    }
    
    func formattedMediumDate() -> String {
        return DateFormatterCache.mediumDate.string(from: self)
    }
    
    func formattedTime() -> String {
        return DateFormatterCache.time.string(from: self)
    }
}
