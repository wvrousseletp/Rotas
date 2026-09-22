import Foundation

public enum TransactionType: String, Codable, CaseIterable, Identifiable {
    case sale = "Venda Direta"
    case consignment = "Consignação"
    case sample = "Amostra Grátis"
    
    public var id: String { self.rawValue }
    
    public var badgeColorName: String {
        switch self {
        case .sale: return "green"
        case .consignment: return "orange"
        case .sample: return "purple"
        }
    }
}

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
@Model
public final class TransactionItem {
    public var id: UUID = UUID()
    public var itemTypeRaw: String = TransactionType.sale.rawValue
    public var quantity: Int = 1
    public var unitPrice: Double = 0.0
    
    @Relationship
    public var product: Product?
    
    @Relationship
    public var visitRecord: VisitRecord?
    
    public var itemType: TransactionType {
        get { TransactionType(rawValue: itemTypeRaw) ?? .sale }
        set { itemTypeRaw = newValue.rawValue }
    }
    
    public var totalPrice: Double {
        return Double(quantity) * unitPrice
    }
    
    public init(
        id: UUID = UUID(),
        itemType: TransactionType = .sale,
        quantity: Int = 1,
        unitPrice: Double,
        product: Product? = nil,
        visitRecord: VisitRecord? = nil
    ) {
        self.id = id
        self.itemTypeRaw = itemType.rawValue
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.product = product
        self.visitRecord = visitRecord
    }
}
#endif
