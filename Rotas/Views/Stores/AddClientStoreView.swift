import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct AddClientStoreView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var priceTables: [PriceTable]
    
    @State private var name: String = ""
    @State private var tradeName: String = ""
    @State private var category: StoreCategory = .supermarket
    @State private var address: String = ""
    @State private var contactName: String = ""
    @State private var contactPhone: String = ""
    @State private var notes: String = ""
    @State private var selectedPriceTableID: UUID?
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Identificação do Ponto de Venda")) {
                    TextField("Razão Social / Nome principal *", text: $name)
                    TextField("Nome Fantasia (Opcional)", text: $tradeName)
                    Picker("Categoria", selection: $category) {
                        ForEach(StoreCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.iconName).tag(cat)
                        }
                    }
                }
                Section(header: Text("Endereço & Localização")) {
                    TextField("Endereço completo *", text: $address)
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
            }
            .navigationTitle("Novo Mercado / Local")
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
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || address.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveStore() {
        let store = ClientStore(
            name: name,
            tradeName: tradeName.isEmpty ? nil : tradeName,
            category: category,
            address: address,
            contactName: contactName.isEmpty ? nil : contactName,
            contactPhone: contactPhone.isEmpty ? nil : contactPhone,
            preferredPriceTableID: selectedPriceTableID,
            notes: notes.isEmpty ? nil : notes
        )
        modelContext.insert(store)
        try? modelContext.save()
        HapticManager.shared.notification(.success)
    }
}
#else
public struct AddClientStoreView: View {
    public init() {}
    public var body: some View { Text("Requer iOS 17+") }
}
#endif
