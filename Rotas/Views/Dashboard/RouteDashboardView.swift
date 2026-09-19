import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct RouteDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Route.scheduledDate, order: .reverse) private var routes: [Route]
    @Query private var stores: [ClientStore]
    
    @State private var selectedRouteID: UUID?
    @State private var selectedStopForVisit: RouteStop?
    @State private var showingCreateRouteSheet = false
    @State private var routeToEdit: Route?
    @State private var showingDeleteRouteAlert = false
    
    public init() {}
    
    private var activeRoute: Route? {
        if let id = selectedRouteID, let found = routes.first(where: { $0.id == id }) {
            return found
        }
        return routes.first(where: { $0.status == .inProgress }) ?? routes.first
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
                            HStack(spacing: 8) {
                                StatusBadgeView(status: route.status)
                                
                                Menu {
                                    Button(action: { routeToEdit = route }) {
                                        Label("Editar Rota", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive, action: { showingDeleteRouteAlert = true }) {
                                        Label("Excluir Rota", systemImage: "trash")
                                    }
                                } label: {
                                    Image(systemName: "ellipsis.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.secondary)
                                }
                            }
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
                        HStack {
                            Text("Paradas da Rota")
                                .font(.headline)
                            Spacer()
                            Text("\(route.sortedStops.count) ponto(s)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 4)
                        
                        if route.sortedStops.isEmpty {
                            VStack(spacing: 8) {
                                Text("Nenhuma parada nesta rota.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Button("Editar Rota para Adicionar Locais") {
                                    routeToEdit = route
                                }
                                .font(.caption)
                                .bold()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                        } else {
                            ForEach(route.sortedStops) { stop in
                                RouteStopRowView(
                                    stop: stop,
                                    onRecordVisit: {
                                        selectedStopForVisit = stop
                                    },
                                    onRemoveStop: {
                                        removeStop(stop, from: route)
                                    }
                                )
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
            if routes.count > 1 {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        ForEach(routes) { r in
                            Button(action: { selectedRouteID = r.id }) {
                                HStack {
                                    Text(r.title)
                                    if r.id == activeRoute?.id {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Label("Trocar Rota", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            
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
        .sheet(item: $routeToEdit) { route in
            CreateRouteSheetView(routeToEdit: route)
        }
        .alert("Excluir Rota", isPresented: $showingDeleteRouteAlert) {
            Button("Excluir", role: .destructive) {
                if let route = activeRoute {
                    deleteRoute(route)
                }
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Tem certeza de que deseja excluir esta rota e suas paradas?")
        }
    }
    
    private func removeStop(_ stop: RouteStop, from route: Route) {
        modelContext.delete(stop)
        try? modelContext.save()
        HapticManager.shared.notification(.warning)
    }
    
    private func deleteRoute(_ route: Route) {
        modelContext.delete(route)
        try? modelContext.save()
        selectedRouteID = nil
        HapticManager.shared.notification(.warning)
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
    let onRemoveStop: () -> Void
    
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
            
            HStack(spacing: 8) {
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
                
                Button(action: onRemoveStop) {
                    Image(systemName: "trash")
                        .font(.subheadline)
                        .foregroundColor(.red.opacity(0.8))
                }
                .buttonStyle(.plain)
                .help("Remover parada da rota")
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
    
    private let routeToEdit: Route?
    
    @State private var title: String = ""
    @State private var scheduledDate: Date = Date()
    @State private var status: RouteStatus = .inProgress
    @State private var selectedStoreIDs: Set<UUID> = []
    @State private var showingDeleteAlert = false
    
    public init(routeToEdit: Route? = nil) {
        self.routeToEdit = routeToEdit
        _title = State(initialValue: routeToEdit?.title ?? "")
        _scheduledDate = State(initialValue: routeToEdit?.scheduledDate ?? Date())
        _status = State(initialValue: routeToEdit?.status ?? .inProgress)
        
        var initialSet = Set<UUID>()
        if let stops = routeToEdit?.stops {
            for stop in stops {
                if let storeID = stop.store?.id {
                    initialSet.insert(storeID)
                }
            }
        }
        _selectedStoreIDs = State(initialValue: initialSet)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Detalhes da Rota")) {
                    TextField("Nome da Rota (ex: Rota Zona Sul)", text: $title)
                    DatePicker("Data Planejada", selection: $scheduledDate, displayedComponents: [.date])
                    Picker("Status da Rota", selection: $status) {
                        ForEach(RouteStatus.allCases) { st in
                            Text(st.rawValue).tag(st)
                        }
                    }
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
                
                if routeToEdit != nil {
                    Section {
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            HStack {
                                Spacer()
                                Label("Excluir Rota", systemImage: "trash.fill")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(routeToEdit == nil ? "Nova Rota" : "Editar Rota")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        saveRoute()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || selectedStoreIDs.isEmpty)
                }
            }
            .alert("Excluir Rota", isPresented: $showingDeleteAlert) {
                Button("Excluir", role: .destructive) {
                    deleteRoute()
                    dismiss()
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Tem certeza de que deseja excluir esta rota?")
            }
        }
    }
    
    private func saveRoute() {
        let finalTitle = title.trimmingCharacters(in: .whitespaces).isEmpty ? "Rota" : title.trimmingCharacters(in: .whitespaces)
        
        if let route = routeToEdit {
            route.title = finalTitle
            route.scheduledDate = scheduledDate
            route.status = status
            
            // Remove stops for unselected stores
            if let existingStops = route.stops {
                for stop in existingStops {
                    if let storeID = stop.store?.id, !selectedStoreIDs.contains(storeID) {
                        modelContext.delete(stop)
                    }
                }
            }
            
            // Add stops for newly selected stores
            let existingStoreIDs = Set(route.stops?.compactMap { $0.store?.id } ?? [])
            var nextIndex = route.stops?.count ?? 0
            for storeID in selectedStoreIDs where !existingStoreIDs.contains(storeID) {
                if let store = stores.first(where: { $0.id == storeID }) {
                    let stop = RouteStop(orderIndex: nextIndex, status: .pending, store: store, route: route)
                    modelContext.insert(stop)
                    nextIndex += 1
                }
            }
        } else {
            let newRoute = Route(title: finalTitle, scheduledDate: scheduledDate, status: status)
            modelContext.insert(newRoute)
            
            var index = 0
            for storeID in selectedStoreIDs {
                if let store = stores.first(where: { $0.id == storeID }) {
                    let stop = RouteStop(orderIndex: index, status: .pending, store: store, route: newRoute)
                    modelContext.insert(stop)
                    index += 1
                }
            }
        }
        
        try? modelContext.save()
        HapticManager.shared.notification(.success)
    }
    
    private func deleteRoute() {
        if let route = routeToEdit {
            modelContext.delete(route)
            try? modelContext.save()
            HapticManager.shared.notification(.warning)
        }
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
