import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    private let productToEdit: Product?
    
    @State private var name: String = ""
    @State private var sku: String = ""
    @State private var unit: String = "Unidade"
    @State private var basePriceString: String = ""
    @State private var category: String = "Geral"
    @State private var showingDeleteAlert = false
    
    let units = ["Unidade", "Caixa", "Kg", "Pacote", "Fardo", "Litro"]
    
    public init(productToEdit: Product? = nil) {
        self.productToEdit = productToEdit
        _name = State(initialValue: productToEdit?.name ?? "")
        _sku = State(initialValue: productToEdit?.sku ?? "")
        _unit = State(initialValue: productToEdit?.unit ?? "Unidade")
        _basePriceString = State(initialValue: productToEdit != nil && productToEdit!.basePrice > 0 ? String(format: "%.2f", productToEdit!.basePrice).replacingOccurrences(of: ".", with: ",") : "")
        _category = State(initialValue: productToEdit?.category ?? "Geral")
    }
    
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
                
                if productToEdit != nil {
                    Section {
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            HStack {
                                Spacer()
                                Label("Excluir Produto", systemImage: "trash.fill")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(productToEdit == nil ? "Novo Produto" : "Editar Produto")
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
            .alert("Excluir Produto", isPresented: $showingDeleteAlert) {
                Button("Excluir", role: .destructive) {
                    deleteProduct()
                    dismiss()
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Tem certeza de que deseja excluir este produto do catálogo?")
            }
        }
    }
    
    private func saveProduct() {
        let price = Double(basePriceString.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let finalName = name.trimmingCharacters(in: .whitespaces).isEmpty ? "Novo Produto" : name.trimmingCharacters(in: .whitespaces)
        
        if let product = productToEdit {
            product.name = finalName
            product.sku = sku.isEmpty ? nil : sku
            product.unit = unit
            product.basePrice = price
            product.category = category
        } else {
            let product = Product(
                name: finalName,
                sku: sku.isEmpty ? nil : sku,
                unit: unit,
                basePrice: price,
                category: category
            )
            modelContext.insert(product)
        }
        try? modelContext.save()
        HapticManager.shared.notification(.success)
    }
    
    private func deleteProduct() {
        if let product = productToEdit {
            modelContext.delete(product)
            try? modelContext.save()
            HapticManager.shared.notification(.warning)
        }
    }
}
#else
public struct AddProductView: View {
    public init(productToEdit: Any? = nil) {}
    public var body: some View { Text("Requer iOS 17+") }
}
#endif
