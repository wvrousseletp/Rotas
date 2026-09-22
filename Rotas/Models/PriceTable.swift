import Foundation

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
@Model
public final class PriceTable {
    public var id: UUID = UUID()
    public var name: String = ""
    public var discountPercentage: Double = 0.0
    public var isDefault: Bool = false
    public var createdAt: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \ProductPriceTable.priceTable)
    public var productPrices: [ProductPriceTable]?
    
    public init(
        id: UUID = UUID(),
        name: String,
        discountPercentage: Double = 0.0,
        isDefault: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.discountPercentage = discountPercentage
        self.isDefault = isDefault
        self.createdAt = createdAt
        self.productPrices = []
    }
}

@available(iOS 17.0, *)
@Model
public final class ProductPriceTable {
    public var id: UUID = UUID()
    public var customPrice: Double = 0.0
    
    @Relationship
    public var priceTable: PriceTable?
    
    @Relationship
    public var product: Product?
    
    public init(
        id: UUID = UUID(),
        customPrice: Double,
        priceTable: PriceTable? = nil,
        product: Product? = nil
    ) {
        self.id = id
        self.customPrice = customPrice
        self.priceTable = priceTable
        self.product = product
    }
}
#endif
