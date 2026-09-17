import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab: AppTab = .dashboard
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                RouteDashboardView()
            }
            .tabItem {
                Label(AppTab.dashboard.title, systemImage: AppTab.dashboard.iconName)
            }
            .tag(AppTab.dashboard)
            
            NavigationStack {
                ClientStoreListView()
            }
            .tabItem {
                Label(AppTab.stores.title, systemImage: AppTab.stores.iconName)
            }
            .tag(AppTab.stores)
            
            NavigationStack {
                ProductCatalogView()
            }
            .tabItem {
                Label(AppTab.products.title, systemImage: AppTab.products.iconName)
            }
            .tag(AppTab.products)
            
            NavigationStack {
                FinancialSummaryView()
            }
            .tabItem {
                Label(AppTab.financial.title, systemImage: AppTab.financial.iconName)
            }
            .tag(AppTab.financial)
        }
        .customSwipeNavigation(
            onSwipeLeft: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedTab = selectedTab.next
                    HapticManager.shared.selection()
                }
            },
            onSwipeRight: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedTab = selectedTab.previous
                    HapticManager.shared.selection()
                }
            }
        )
        .preferredColorScheme(.dark)
        .tint(.accentColor)
    }
}
