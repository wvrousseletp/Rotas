import Foundation

public enum ManagerStatus: String, Codable, CaseIterable, Identifiable {
    case spokenWithManager = "Atendido pelo Gerente"
    case managerAbsent = "Gerente Ausente (Revisitar)"
    case noManagerNeeded = "Sem necessidade de Gerência"
    
    public var id: String { self.rawValue }
    
    public var iconName: String {
        switch self {
        case .spokenWithManager: return "person.fill.checkmark"
        case .managerAbsent: return "person.fill.xmark"
        case .noManagerNeeded: return "person.fill"
        }
    }
}

public enum PaymentMethod: String, Codable, CaseIterable, Identifiable {
    case pix = "PIX"
    case boleto = "Boleto"
    case cash = "Dinheiro"
    case creditCard = "Cartão de Crédito"
    case pending = "A Definir / Pendente"
    
    public var id: String { self.rawValue }
}

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
@Model
public final class VisitRecord {
    public var id: UUID
    public var timestamp: Date
    public var managerStatusRaw: String
    public var paymentMethodRaw: String
    public var paymentTermDays: Int
    public var paymentDueDate: Date?
    public var isPaid: Bool
    public var notes: String?
    
    @Relationship(deleteRule: .cascade, inverse: \TransactionItem.visitRecord)
    public var items: [TransactionItem]?
    
    @Relationship
    public var routeStop: RouteStop?
    
    public var managerStatus: ManagerStatus {
        get { ManagerStatus(rawValue: managerStatusRaw) ?? .spokenWithManager }
        set { managerStatusRaw = newValue.rawValue }
    }
    
    public var paymentMethod: PaymentMethod {
        get { PaymentMethod(rawValue: paymentMethodRaw) ?? .pix }
        set { paymentMethodRaw = newValue.rawValue }
    }
    
    public var totalAmount: Double {
        return items?.reduce(0.0) { $0 + $1.totalPrice } ?? 0.0
    }
    
    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        managerStatus: ManagerStatus = .spokenWithManager,
        paymentMethod: PaymentMethod = .pix,
        paymentTermDays: Int = 0,
        paymentDueDate: Date? = nil,
        isPaid: Bool = false,
        notes: String? = nil,
        routeStop: RouteStop? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.managerStatusRaw = managerStatus.rawValue
        self.paymentMethodRaw = paymentMethod.rawValue
        self.paymentTermDays = paymentTermDays
        self.paymentDueDate = paymentDueDate
        self.isPaid = isPaid
        self.notes = notes
        self.routeStop = routeStop
        self.items = []
    }
}
#endif
