import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct PriceTableListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PriceTable.name) private var priceTables: [PriceTable]
    
    @State private var showingAddTableSheet = false
    @State private var newTableName: String = ""
    @State private var newDiscountString: String = "0"
    
    public init() {}
    
    public var body: some View {
        List {
            Section(header: Text("Tabelas de Preços Cadastradas")) {
                if priceTables.isEmpty {
                    Text("Nenhuma tabela de preço cadastrada.").foregroundColor(.secondary)
                } else {
                    ForEach(priceTables) { table in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(table.name).font(.headline)
                                if table.discountPercentage > 0 {
                                    Text("Desconto padrão: \(table.discountPercentage, specifier: "%.1f")%")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            Spacer()
                            if table.isDefault {
                                Text("Padrão")
                                    .font(.caption2)
                                    .bold()
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .onDelete(perform: deleteTables)
                }
            }
        }
        .navigationTitle("Tabelas de Preços")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddTableSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTableSheet) {
            NavigationStack {
                Form {
                    Section(header: Text("Nova Tabela")) {
                        TextField("Nome da Tabela (ex: Atacado Supermercados)", text: $newTableName)
                        TextField("Desconto Padrão (%)", text: $newDiscountString)
                            .keyboardType(.decimalPad)
                    }
                }
                .navigationTitle("Criar Tabela")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") { showingAddTableSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Salvar") {
                            createPriceTable()
                            showingAddTableSheet = false
                        }
                        .disabled(newTableName.isEmpty)
                    }
                }
            }
        }
    }
    
    private func createPriceTable() {
        let discount = Double(newDiscountString.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let table = PriceTable(name: newTableName, discountPercentage: discount)
        modelContext.insert(table)
        try? modelContext.save()
        newTableName = ""
        newDiscountString = "0"
    }
    
    private func deleteTables(offsets: IndexSet) {
        for index in offsets {
            let table = priceTables[index]
            modelContext.delete(table)
        }
        try? modelContext.save()
    }
}
#else
public struct PriceTableListView: View {
    public init() {}
    public var body: some View { Text("PriceTableListView requer iOS 17+") }
}
#endif
