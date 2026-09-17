import Foundation

public enum StopStatus: String, Codable, CaseIterable, Identifiable {
    case pending = "Pendente"
    case visited = "Visitado"
    case managerAbsent = "Gerente Ausente"
    case skipped = "Pulado"
    
    public var id: String { self.rawValue }
    
    public var iconName: String {
        switch self {
        case .pending: return "clock.fill"
        case .visited: return "checkmark.circle.fill"
        case .managerAbsent: return "exclamationmark.triangle.fill"
        case .skipped: return "forward.fill"
        }
    }
}

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
@Model
public final class RouteStop {
    public var id: UUID
    public var orderIndex: Int
    public var statusRaw: String
    public var visitedAt: Date?
    public var notes: String?
    
    @Relationship
    public var store: ClientStore?
    
    @Relationship
    public var route: Route?
    
    @Relationship(deleteRule: .cascade, inverse: \VisitRecord.routeStop)
    public var visitRecords: [VisitRecord]?
    
    public var status: StopStatus {
        get { StopStatus(rawValue: statusRaw) ?? .pending }
        set { statusRaw = newValue.rawValue }
    }
    
    public init(
        id: UUID = UUID(),
        orderIndex: Int,
        status: StopStatus = .pending,
        visitedAt: Date? = nil,
        notes: String? = nil,
        store: ClientStore? = nil,
        route: Route? = nil
    ) {
        self.id = id
        self.orderIndex = orderIndex
        self.statusRaw = status.rawValue
        self.visitedAt = visitedAt
        self.notes = notes
        self.store = store
        self.route = route
        self.visitRecords = []
    }
}
#endif
