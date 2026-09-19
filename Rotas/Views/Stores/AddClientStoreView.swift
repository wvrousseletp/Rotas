import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct AddClientStoreView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var priceTables: [PriceTable]
    
    private let storeToEdit: ClientStore?
    
    @State private var name: String = ""
    @State private var tradeName: String = ""
    @State private var category: StoreCategory = .supermarket
    @State private var address: String = ""
    @State private var contactName: String = ""
    @State private var contactPhone: String = ""
    @State private var notes: String = ""
    @State private var selectedPriceTableID: UUID?
    @State private var showingDeleteAlert = false
    
    public init(storeToEdit: ClientStore? = nil) {
        self.storeToEdit = storeToEdit
        _name = State(initialValue: storeToEdit?.name ?? "")
        _tradeName = State(initialValue: storeToEdit?.tradeName ?? "")
        _category = State(initialValue: storeToEdit?.category ?? .supermarket)
        _address = State(initialValue: storeToEdit?.address ?? "")
        _contactName = State(initialValue: storeToEdit?.contactName ?? "")
        _contactPhone = State(initialValue: storeToEdit?.contactPhone ?? "")
        _notes = State(initialValue: storeToEdit?.notes ?? "")
        _selectedPriceTableID = State(initialValue: storeToEdit?.preferredPriceTableID)
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Identificação do Ponto de Venda")) {
                    TextField("Razão Social / Nome principal", text: $name)
                    TextField("Nome Fantasia (Opcional)", text: $tradeName)
                    Picker("Categoria", selection: $category) {
                        ForEach(StoreCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.iconName).tag(cat)
                        }
                    }
                }
                Section(header: Text("Endereço & Localização")) {
                    TextField("Endereço completo", text: $address)
                }
                Section(header: Text("Contato Comercial")) {
                    TextField("Nome do Gerente / Comprador", text: $contactName)
                    TextField("Telefone / WhatsApp", text: $contactPhone)
                        .keyboardType(.phonePad)
                }
                Section(header: Text("Condições de Preço")) {
                    Picker("Tabela de Preço Preferencial", selection: $selectedPriceTableID) {
                        Text("Preço Base / Padrão").tag(UUID?.none)
                        ForEach(priceTables) { table in
                            Text(table.name).tag(UUID?.some(table.id))
                        }
                    }
                }
                Section(header: Text("Observações Gerais")) {
                    TextField("Anotações adicionais...", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                if storeToEdit != nil {
                    Section {
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            HStack {
                                Spacer()
                                Label("Excluir Mercado / Local", systemImage: "trash.fill")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(storeToEdit == nil ? "Novo Mercado / Local" : "Editar Local")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        saveStore()
                        dismiss()
                    }
                }
            }
            .alert("Excluir Local", isPresented: $showingDeleteAlert) {
                Button("Excluir", role: .destructive) {
                    deleteStore()
                    dismiss()
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Tem certeza de que deseja excluir este local? Esta ação não poderá ser desfeita.")
            }
        }
    }
    
    private func saveStore() {
        let finalName = name.trimmingCharacters(in: .whitespaces).isEmpty ? "Novo Local" : name.trimmingCharacters(in: .whitespaces)
        let finalAddress = address.trimmingCharacters(in: .whitespaces).isEmpty ? "Sem endereço cadastrado" : address.trimmingCharacters(in: .whitespaces)
        
        if let store = storeToEdit {
            store.name = finalName
            store.tradeName = tradeName.isEmpty ? nil : tradeName
            store.category = category
            store.address = finalAddress
            store.contactName = contactName.isEmpty ? nil : contactName
            store.contactPhone = contactPhone.isEmpty ? nil : contactPhone
            store.preferredPriceTableID = selectedPriceTableID
            store.notes = notes.isEmpty ? nil : notes
        } else {
            let store = ClientStore(
                name: finalName,
                tradeName: tradeName.isEmpty ? nil : tradeName,
                category: category,
                address: finalAddress,
                contactName: contactName.isEmpty ? nil : contactName,
                contactPhone: contactPhone.isEmpty ? nil : contactPhone,
                preferredPriceTableID: selectedPriceTableID,
                notes: notes.isEmpty ? nil : notes
            )
            modelContext.insert(store)
        }
        try? modelContext.save()
        HapticManager.shared.notification(.success)
    }
    
    private func deleteStore() {
        if let store = storeToEdit {
            modelContext.delete(store)
            try? modelContext.save()
            HapticManager.shared.notification(.warning)
        }
    }
}
#else
public struct AddClientStoreView: View {
    public init(storeToEdit: Any? = nil) {}
    public var body: some View { Text("Requer iOS 17+") }
}
#endif
