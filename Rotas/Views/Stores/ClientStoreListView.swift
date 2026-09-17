import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct ClientStoreListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ClientStore.name) private var stores: [ClientStore]
    
    @State private var searchText: String = ""
    @State private var showingAddStoreSheet = false
    
    public init() {}
    
    private var filteredStores: [ClientStore] {
        if searchText.isEmpty { return stores }
        return stores.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.address.localizedCaseInsensitiveContains(searchText) ||
            ($0.contactName?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    public var body: some View {
        Group {
            if stores.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "storefront.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.accentColor)
                    Text("Nenhum Mercado Cadastrado")
                        .font(.title3)
                        .bold()
                    Text("Cadastre seus pontos de venda para começar a criar rotas de visita e acompanhamento.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button(action: { showingAddStoreSheet = true }) {
                        Label("Cadastrar Primeiro Local", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
            } else {
                List {
                    ForEach(filteredStores) { store in
                        NavigationLink(destination: ClientStoreDetailView(store: store)) {
                            HStack(spacing: 14) {
                                Image(systemName: store.category.iconName)
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                                    .frame(width: 36, height: 36)
                                    .background(Color.accentColor.opacity(0.15))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(store.name).font(.headline)
                                    Text(store.address).font(.caption).foregroundColor(.secondary).lineLimit(1)
                                    if let contact = store.contactName {
                                        Text("Contato: \(contact)").font(.caption2).foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteStores)
                }
                .searchable(text: $searchText, prompt: "Buscar local ou endereço")
            }
        }
        .navigationTitle("Locais / Mercados")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddStoreSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddStoreSheet) {
            AddClientStoreView()
        }
    }
    
    private func deleteStores(offsets: IndexSet) {
        for index in offsets {
            let store = filteredStores[index]
            modelContext.delete(store)
        }
        try? modelContext.save()
    }
}
#else
public struct ClientStoreListView: View {
    public init() {}
    public var body: some View { Text("ClientStoreListView requer iOS 17+") }
}
#endif
