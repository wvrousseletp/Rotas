import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct PriceTableDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var priceTable: PriceTable
    
    @Query(sort: \Product.name) private var allProducts: [Product]
    
    @State private var searchText: String = ""
    
    public init(priceTable: PriceTable) {
        self.priceTable = priceTable
    }
    
    private var filteredProducts: [Product] {
        if searchText.isEmpty { return allProducts }
        return allProducts.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            ($0.sku?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    public var body: some View {
        Form {
            Section(header: Text("Informações da Tabela")) {
                TextField("Nome da Tabela", text: $priceTable.name)
                
                HStack {
                    Text("Desconto Padrão (Opcional / Fallback)")
                    Spacer()
                    TextField("0", value: $priceTable.discountPercentage, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 60)
                    Text("%")
                }
            }
            
            Section(
                header: Text("Preço Específico por Produto"),
                footer: Text("Digite o valor exato em R$ para cada produto cadastrado. Os valores salvos serão usados automaticamente no check-in de visitas dos locais associados a esta tabela.")
            ) {
                if allProducts.isEmpty {
                    Text("Nenhum produto cadastrado no catálogo.").foregroundColor(.secondary)
                } else {
                    ForEach(filteredProducts) { product in
                        ProductPriceRow(
                            product: product,
                            priceTable: priceTable,
                            onSavePrice: { newPrice in
                                saveCustomPrice(for: product, newPrice: newPrice)
                            },
                            onClearPrice: {
                                clearCustomPrice(for: product)
                            }
                        )
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Buscar produto por nome ou categoria...")
        .navigationTitle(priceTable.name.isEmpty ? "Tabela de Preço" : priceTable.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveCustomPrice(for product: Product, newPrice: Double) {
        if let existing = priceTable.productPrices?.first(where: { $0.product?.id == product.id }) {
            existing.customPrice = newPrice
        } else {
            let ppt = ProductPriceTable(customPrice: newPrice, priceTable: priceTable, product: product)
            modelContext.insert(ppt)
        }
        try? modelContext.save()
    }
    
    private func clearCustomPrice(for product: Product) {
        if let existing = priceTable.productPrices?.first(where: { $0.product?.id == product.id }) {
            modelContext.delete(existing)
            try? modelContext.save()
        }
    }
}

@available(iOS 17.0, *)
private struct ProductPriceRow: View {
    let product: Product
    let priceTable: PriceTable
    let onSavePrice: (Double) -> Void
    let onClearPrice: () -> Void
    
    @State private var priceText: String = ""
    
    private var customEntry: ProductPriceTable? {
        priceTable.productPrices?.first(where: { $0.product?.id == product.id })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.name)
                        .font(.headline)
                    Text("Preço Base: \(product.basePrice.formattedAsBRL())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                if customEntry != nil {
                    Text("Preço Específico")
                        .font(.caption2)
                        .bold()
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .clipShape(Capsule())
                } else if priceTable.discountPercentage > 0 {
                    Text("Desconto \(priceTable.discountPercentage, specifier: "%.0f")%")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.blue.opacity(0.15))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                }
            }
            
            HStack {
                Text("Preço nesta tabela: R$")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("0,00", text: $priceText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 120)
                    .onChange(of: priceText) { _, newValue in
                        let clean = newValue.replacingOccurrences(of: ",", with: ".")
                        if let val = Double(clean), val >= 0 {
                            onSavePrice(val)
                        }
                    }
                
                if customEntry != nil {
                    Button(action: {
                        onClearPrice()
                        loadCurrentPrice()
                    }) {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                    .help("Restaurar preço padrão")
                }
            }
        }
        .padding(.vertical, 4)
        .onAppear {
            loadCurrentPrice()
        }
    }
    
    private func loadCurrentPrice() {
        if let custom = customEntry {
            priceText = String(format: "%.2f", custom.customPrice).replacingOccurrences(of: ".", with: ",")
        } else {
            let effective = product.price(for: priceTable)
            priceText = String(format: "%.2f", effective).replacingOccurrences(of: ".", with: ",")
        }
    }
}
#endif
