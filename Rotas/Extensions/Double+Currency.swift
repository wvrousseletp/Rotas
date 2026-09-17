import Foundation

public extension Double {
    func formattedAsBRL() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: self)) ?? String(format: "R$ %.2f", self)
    }
}
