import Foundation

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
@Model
public final class Product {
    public var id: UUID
    public var name: String
    public var sku: String?
    public var unit: String
    public var basePrice: Double
    public var category: String
    public var isActive: Bool
    public var createdAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \ProductPriceTable.product)
    public var customPrices: [ProductPriceTable]?
    
    public init(
        id: UUID = UUID(),
        name: String,
        sku: String? = nil,
        unit: String = "Unidade",
        basePrice: Double = 0.0,
        category: String = "Geral",
        isActive: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.sku = sku
        self.unit = unit
        self.basePrice = basePrice
        self.category = category
        self.isActive = isActive
        self.createdAt = createdAt
        self.customPrices = []
    }
    
    public func price(for priceTable: PriceTable?) -> Double {
        guard let priceTable = priceTable else { return basePrice }
        if let custom = customPrices?.first(where: { $0.priceTable?.id == priceTable.id }) {
            return custom.customPrice
        }
        if priceTable.discountPercentage > 0 && basePrice > 0 {
            return basePrice * (1.0 - (priceTable.discountPercentage / 100.0))
        }
        return basePrice
    }
}
#endif
