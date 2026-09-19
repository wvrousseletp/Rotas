import Foundation

private enum CurrencyFormatterCache {
    static let brlFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()
}

public extension Double {
    func formattedAsBRL() -> String {
        return CurrencyFormatterCache.brlFormatter.string(from: NSNumber(value: self)) ?? String(format: "R$ %.2f", self)
    }
}
