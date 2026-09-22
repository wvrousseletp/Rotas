import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
@main
struct RotasApp: App {
    let container: ModelContainer
    
    init() {
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
        
        do {
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .automatic)
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            print("CloudKit ModelContainer initialization failed (\(error.localizedDescription)). Retrying with local store configuration...")
            do {
                let localConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .none)
                container = try ModelContainer(for: schema, configurations: [localConfig])
            } catch {
                print("Local ModelContainer initialization failed (\(error.localizedDescription)). Falling back to in-memory store...")
                do {
                    let inMemoryConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                    container = try ModelContainer(for: schema, configurations: [inMemoryConfig])
                } catch {
                    fatalError("Critical error: Unable to create ModelContainer: \(error.localizedDescription)")
                }
            }
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
