import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct ProductCatalogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Product.name) private var products: [Product]
    
    @State private var searchText: String = ""
    @State private var showingAddProductSheet = false
    
    public init() {}
    
    private var filteredProducts: [Product] {
        if searchText.isEmpty { return products }
        return products.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            ($0.sku?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    public var body: some View {
        Group {
            if products.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "box.truck.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.accentColor)
                    Text("Nenhum Produto Cadastrado")
                        .font(.title3)
                        .bold()
                    Text("Cadastre seus produtos fabricados para definir tabelas de preço e registrar vendas ou consignação.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button(action: { showingAddProductSheet = true }) {
                        Label("Cadastrar Primeiro Produto", systemImage: "plus.circle.fill")
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
                    Section {
                        NavigationLink(destination: PriceTableListView()) {
                            Label("Gerenciar Tabelas de Preços", systemImage: "tag.fill")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Section(header: Text("Catálogo de Produtos")) {
                        ForEach(filteredProducts) { product in
                            ProductRowView(product: product)
                        }
                        .onDelete(perform: deleteProducts)
                    }
                }
                .searchable(text: $searchText, prompt: "Buscar por nome, SKU ou categoria")
            }
        }
        .navigationTitle("Produtos & Preços")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddProductSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddProductSheet) {
            AddProductView()
        }
    }
    
    private func deleteProducts(offsets: IndexSet) {
        for index in offsets {
            let product = filteredProducts[index]
            modelContext.delete(product)
        }
        try? modelContext.save()
    }
}

@available(iOS 17.0, *)
private struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name).font(.headline)
                if let sku = product.sku {
                    Text("SKU: \(sku)").font(.caption2).foregroundColor(.secondary)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(product.basePrice.formattedAsBRL())
                    .font(.headline)
                    .foregroundColor(.green)
                Text("por \(product.unit)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}
#else
public struct ProductCatalogView: View {
    public init() {}
    public var body: some View { Text("ProductCatalogView requer iOS 17+") }
}
#endif
