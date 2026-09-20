import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
@main
struct RotasApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                ClientStore.self,
                Product.self,
                PriceTable.self,
                ProductPriceTable.self,
                Route.self,
                RouteStop.self,
                VisitRecord.self,
                TransactionItem.self
            ])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to initialize SwiftData ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }
        }
        .modelContainer(container)
    }
}
#else
@main
struct RotasApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Rotas App requer iOS 17+ / Xcode 15+ com SwiftData.")
        }
    }
}
#endif
