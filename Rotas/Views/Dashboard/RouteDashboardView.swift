import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct RouteDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Route.scheduledDate, order: .reverse) private var routes: [Route]
    @Query private var stores: [ClientStore]
    
    @State private var selectedStopForVisit: RouteStop?
    @State private var showingCreateRouteSheet = false
    
    public init() {}
    
    private var activeRoute: Route? {
        routes.first(where: { $0.status == .inProgress }) ?? routes.first
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let route = activeRoute {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(route.title)
                                    .font(.title2)
                                    .bold()
                                Text(route.scheduledDate.formattedMediumDate())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            StatusBadgeView(status: route.status)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Progresso das Visitas")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(route.completedStopsCount)/\(route.totalStopsCount) Concluídos")
                                    .font(.caption)
                                    .bold()
                            }
                            ProgressView(value: route.progressFraction)
                                .tint(.green)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Paradas da Rota")
                            .font(.headline)
                            .padding(.horizontal, 4)
                        
                        if route.sortedStops.isEmpty {
                            Text("Nenhuma parada adicionada nesta rota.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ForEach(route.sortedStops) { stop in
                                RouteStopRowView(stop: stop) {
                                    selectedStopForVisit = stop
                                }
                            }
                        }
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "map.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.accentColor)
                        
                        Text("Nenhuma Rota Ativa")
                            .font(.title3)
                            .bold()
                        
                        Text("Crie uma nova rota para organizar suas visitas aos pontos de venda e mercados hoje.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: { showingCreateRouteSheet = true }) {
                            Label("Criar Nova Rota", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                }
            }
            .padding()
        }
        .navigationTitle("Rota do Dia")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingCreateRouteSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(item: $selectedStopForVisit) { stop in
            RecordVisitSheetView(stop: stop)
        }
        .sheet(isPresented: $showingCreateRouteSheet) {
            CreateRouteSheetView()
        }
    }
}

@available(iOS 17.0, *)
struct StatusBadgeView: View {
    let status: RouteStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
    
    var color: Color {
        switch status {
        case .planned: return .blue
        case .inProgress: return .orange
        case .completed: return .green
        case .cancelled: return .red
        }
    }
}

@available(iOS 17.0, *)
struct RouteStopRowView: View {
    let stop: RouteStop
    let onRecordVisit: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(colorForStatus(stop.status))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: stop.status.iconName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stop.store?.name ?? "Ponto de Venda")
                    .font(.headline)
                
                if let address = stop.store?.address {
                    Text(address)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Button(action: onRecordVisit) {
                Text(stop.status == .visited ? "Editar" : "Atender")
                    .font(.subheadline)
                    .bold()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentColor.opacity(0.15))
                    .foregroundColor(.accentColor)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private func colorForStatus(_ status: StopStatus) -> Color {
        switch status {
        case .pending: return .gray
        case .visited: return .green
        case .managerAbsent: return .orange
        case .skipped: return .red
        }
    }
}

@available(iOS 17.0, *)
struct CreateRouteSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var stores: [ClientStore]
    
    @State private var title: String = ""
    @State private var scheduledDate: Date = Date()
    @State private var selectedStoreIDs: Set<UUID> = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Detalhes da Rota")) {
                    TextField("Nome da Rota (ex: Rota Zona Sul)", text: $title)
                    DatePicker("Data Planejada", selection: $scheduledDate, displayedComponents: [.date])
                }
                
                Section(header: Text("Selecionar Locais a Visitar")) {
                    if stores.isEmpty {
                        Text("Nenhum local cadastrado. Cadastre locais na aba 'Locais' primeiro.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(stores) { store in
                            Toggle(isOn: Binding(
                                get: { selectedStoreIDs.contains(store.id) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedStoreIDs.insert(store.id)
                                    } else {
                                        selectedStoreIDs.remove(store.id)
                                    }
                                }
                            )) {
                                VStack(alignment: .leading) {
                                    Text(store.name)
                                        .font(.body)
                                    Text(store.address)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Nova Rota")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Criar") {
                        createRoute()
                        dismiss()
                    }
                    .disabled(title.isEmpty || selectedStoreIDs.isEmpty)
                }
            }
        }
    }
    
    private func createRoute() {
        let newRoute = Route(title: title, scheduledDate: scheduledDate, status: .inProgress)
        modelContext.insert(newRoute)
        
        var index = 0
        for storeID in selectedStoreIDs {
            if let store = stores.first(where: { $0.id == storeID }) {
                let stop = RouteStop(orderIndex: index, status: .pending, store: store, route: newRoute)
                modelContext.insert(stop)
                index += 1
            }
        }
        
        try? modelContext.save()
        HapticManager.shared.notification(.success)
    }
}
#else
public struct RouteDashboardView: View {
    public init() {}
    public var body: some View {
        Text("RouteDashboardView requer iOS 17+")
    }
}
#endif
