import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct ClientStoreDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let store: ClientStore
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    public init(store: ClientStore) {
        self.store = store
    }
    
    public var body: some View {
        List {
            Section(header: Text("Informações Gerais")) {
                LabeledContent("Nome / Razão Social", value: store.name)
                if let trade = store.tradeName {
                    LabeledContent("Nome Fantasia", value: trade)
                }
                LabeledContent("Categoria", value: store.category.rawValue)
                LabeledContent("Endereço", value: store.address)
            }
            
            Section(header: Text("Contato Comercial")) {
                if let contact = store.contactName {
                    LabeledContent("Gerente / Comprador", value: contact)
                } else {
                    Text("Nenhum contato cadastrado.").foregroundColor(.secondary)
                }
                if let phone = store.contactPhone {
                    LabeledContent("Telefone / WhatsApp", value: phone)
                }
            }
            
            if let notes = store.notes {
                Section(header: Text("Observações")) {
                    Text(notes).font(.subheadline)
                }
            }
            
            Section {
                Button(role: .destructive, action: { showingDeleteAlert = true }) {
                    HStack {
                        Spacer()
                        Label("Excluir Local", systemImage: "trash.fill")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(store.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Editar") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddClientStoreView(storeToEdit: store)
        }
        .alert("Excluir Local", isPresented: $showingDeleteAlert) {
            Button("Excluir", role: .destructive) {
                modelContext.delete(store)
                try? modelContext.save()
                HapticManager.shared.notification(.warning)
                dismiss()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Tem certeza de que deseja excluir este local? Todas as paradas de rota associadas também serão removidas.")
        }
    }
}
#else
public struct ClientStoreDetailView: View {
    public init(store: Any) {}
    public var body: some View { Text("ClientStoreDetailView requer iOS 17+") }
}
#endif
