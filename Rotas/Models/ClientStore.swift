import Foundation
import SwiftUI

public enum StoreCategory: String, Codable, CaseIterable, Identifiable {
    case supermarket = "Supermercado"
    case grocery = "Mercearia"
    case convenience = "Conveniência"
    case bakery = "Padaria"
    case restaurant = "Restaurante / Lanchonete"
    case other = "Outro"
    
    public var id: String { self.rawValue }
    
    public var iconName: String {
        switch self {
        case .supermarket: return "cart.fill"
        case .grocery: return "basket.fill"
        case .convenience: return "storefront.fill"
        case .bakery: return "cup.and.saucer.fill"
        case .restaurant: return "fork.knife"
        case .other: return "building.2.fill"
        }
    }
}

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
@Model
public final class ClientStore {
    public var id: UUID
    public var name: String
    public var tradeName: String?
    public var categoryRaw: String
    public var address: String
    public var latitude: Double?
    public var longitude: Double?
    public var contactName: String?
    public var contactPhone: String?
    public var preferredPriceTableID: UUID?
    public var notes: String?
    public var createdAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \RouteStop.store)
    public var routeStops: [RouteStop]?
    
    public var category: StoreCategory {
        get { StoreCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }
    
    public init(
        id: UUID = UUID(),
        name: String,
        tradeName: String? = nil,
        category: StoreCategory = .supermarket,
        address: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        contactName: String? = nil,
        contactPhone: String? = nil,
        preferredPriceTableID: UUID? = nil,
        notes: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.tradeName = tradeName
        self.categoryRaw = category.rawValue
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.contactName = contactName
        self.contactPhone = contactPhone
        self.preferredPriceTableID = preferredPriceTableID
        self.notes = notes
        self.createdAt = createdAt
        self.routeStops = []
    }
}
#endif
