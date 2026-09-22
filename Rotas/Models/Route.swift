import Foundation

public enum RouteStatus: String, Codable, CaseIterable, Identifiable {
    case planned = "Planejada"
    case inProgress = "Em Andamento"
    case completed = "Concluída"
    case cancelled = "Cancelada"
    
    public var id: String { self.rawValue }
}

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
@Model
public final class Route {
    public var id: UUID = UUID()
    public var title: String = ""
    public var scheduledDate: Date = Date()
    public var statusRaw: String = RouteStatus.planned.rawValue
    public var createdAt: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \RouteStop.route)
    public var stops: [RouteStop]?
    
    public var status: RouteStatus {
        get { RouteStatus(rawValue: statusRaw) ?? .planned }
        set { statusRaw = newValue.rawValue }
    }
    
    public var sortedStops: [RouteStop] {
        return (stops ?? []).sorted { $0.orderIndex < $1.orderIndex }
    }
    
    public var completedStopsCount: Int {
        return (stops ?? []).filter { $0.status == .visited }.count
    }
    
    public var totalStopsCount: Int {
        return stops?.count ?? 0
    }
    
    public var progressFraction: Double {
        guard totalStopsCount > 0 else { return 0.0 }
        return Double(completedStopsCount) / Double(totalStopsCount)
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        scheduledDate: Date = Date(),
        status: RouteStatus = .planned,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.scheduledDate = scheduledDate
        self.statusRaw = status.rawValue
        self.createdAt = createdAt
        self.stops = []
    }
}
#endif
