import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    @State private var sku: String = ""
    @State private var unit: String = "Unidade"
    @State private var basePriceString: String = ""
    @State private var category: String = "Geral"
    
    let units = ["Unidade", "Caixa", "Kg", "Pacote", "Fardo", "Litro"]
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informações do Produto")) {
                    TextField("Nome do Produto", text: $name)
                    TextField("SKU / Código (Opcional)", text: $sku)
                    TextField("Categoria", text: $category)
                }
                Section(header: Text("Unidade & Preço Base (Opcional)")) {
                    Picker("Unidade de Medida", selection: $unit) {
                        ForEach(units, id: \.self) { u in Text(u).tag(u) }
                    }
                    TextField("Preço Base R$ (Opcional)", text: $basePriceString)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Novo Produto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        saveProduct()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveProduct() {
        let price = Double(basePriceString.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let finalName = name.trimmingCharacters(in: .whitespaces).isEmpty ? "Novo Produto" : name.trimmingCharacters(in: .whitespaces)
        let product = Product(
            name: finalName,
            sku: sku.isEmpty ? nil : sku,
            unit: unit,
            basePrice: price,
            category: category
        )
        modelContext.insert(product)
        try? modelContext.save()
        HapticManager.shared.notification(.success)
    }
}
#else
public struct AddProductView: View {
    public init() {}
    public var body: some View { Text("Requer iOS 17+") }
}
#endif
