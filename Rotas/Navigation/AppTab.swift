import SwiftUI

public enum AppTab: Int, CaseIterable, Identifiable {
    case dashboard = 0
    case stores = 1
    case products = 2
    case financial = 3
    
    public var id: Int { self.rawValue }
    
    public var title: String {
        switch self {
        case .dashboard: return "Rotas"
        case .stores: return "Locais"
        case .products: return "Produtos"
        case .financial: return "Financeiro"
        }
    }
    
    public var iconName: String {
        switch self {
        case .dashboard: return "map.fill"
        case .stores: return "storefront.fill"
        case .products: return "box.truck.fill"
        case .financial: return "dollarsign.circle.fill"
        }
    }
    
    public var next: AppTab {
        let nextRaw = (self.rawValue + 1) % AppTab.allCases.count
        return AppTab(rawValue: nextRaw) ?? .dashboard
    }
    
    public var previous: AppTab {
        let prevRaw = (self.rawValue - 1 + AppTab.allCases.count) % AppTab.allCases.count
        return AppTab(rawValue: prevRaw) ?? .financial
    }
}
