import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct RecordVisitSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let stop: RouteStop
    
    @Query private var allProducts: [Product]
    @Query private var priceTables: [PriceTable]
    
    private var availableProducts: [Product] {
        allProducts.filter { $0.isActive }
    }
    
    @State private var selectedPriceTableID: UUID?
    @State private var managerStatus: ManagerStatus = .spokenWithManager
    @State private var visitPurpose: TransactionType = .consignment
    @State private var selectedPaymentMethod: PaymentMethod = .pix
    @State private var paymentTermDays: Int = 15
    @State private var notes: String = ""
    @State private var isPaid: Bool = false
    @State private var reminderDate: Date = Date().addingTimeInterval(86400 * 2)
    @State private var productQuantities: [UUID: Int] = [:]
    
    public init(stop: RouteStop) {
        self.stop = stop
        _selectedPriceTableID = State(initialValue: stop.store?.preferredPriceTableID)
    }
    
    private var selectedPriceTable: PriceTable? {
        guard let tableID = selectedPriceTableID else { return nil }
        return priceTables.first { $0.id == tableID }
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informações do Local")) {
                    HStack {
                        Image(systemName: stop.store?.category.iconName ?? "storefront.fill")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(stop.store?.name ?? "Ponto de Venda")
                                .font(.headline)
                            if let contact = stop.store?.contactName, !contact.isEmpty {
                                Text("Contato: \(contact)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section(header: Text("Atendimento ao Gerente Comercial")) {
                    Picker("Status do Atendimento", selection: $managerStatus) {
                        ForEach(ManagerStatus.allCases) { status in
                            Label(status.rawValue, systemImage: status.iconName).tag(status)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    if managerStatus == .managerAbsent {
                        DatePicker("Lembrar de Revisitar em", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Tabela de Preços da Visita")) {
                    Picker("Tabela de Preço Aplicada", selection: $selectedPriceTableID) {
                        Text("Preço Base / Padrão").tag(UUID?.none)
                        ForEach(priceTables) { table in
                            Text(table.name).tag(UUID?.some(table.id))
                        }
                    }
                }
                
                Section(header: Text(selectedPriceTable != nil ? "Produtos Deixados / Vendidos (\(selectedPriceTable!.name))" : "Produtos Deixados / Vendidos")) {
                    if availableProducts.isEmpty {
                        Text("Nenhum produto cadastrado no catálogo.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(availableProducts) { product in
                            ProductQuantityRowView(
                                product: product,
                                storePriceTable: selectedPriceTable,
                                quantity: productQuantities[product.id] ?? 0,
                                onIncrement: {
                                    let current = productQuantities[product.id] ?? 0
                                    productQuantities[product.id] = current + 1
                                    HapticManager.shared.impact(.light)
                                },
                                onDecrement: {
                                    let current = productQuantities[product.id] ?? 0
                                    if current > 0 {
                                        productQuantities[product.id] = current - 1
                                        HapticManager.shared.impact(.light)
                                    }
                                }
                            )
                        }
                    }
                }
                
                Section(header: Text("Tipo de Entrega e Pagamento")) {
                    Picker("Tipo de Operação", selection: $visitPurpose) {
                        ForEach(TransactionType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    if visitPurpose != .sample {
                        Picker("Forma de Pagamento", selection: $selectedPaymentMethod) {
                            ForEach(PaymentMethod.allCases) { method in
                                Text(method.rawValue).tag(method)
                            }
                        }
                        
                        HStack {
                            Text("Prazo de Pagamento")
                            Spacer()
                            TextField("0", value: $paymentTermDays, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 50)
                                .textFieldStyle(.roundedBorder)
                            Text("dias")
                            Stepper("", value: $paymentTermDays, in: 0...365)
                                .labelsHidden()
                        }
                        
                        Toggle("Já foi pago no ato?", isOn: $isPaid)
                    }
                }
                
                Section(header: Text("Observações")) {
                    TextField("Anotações da visita...", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("Registrar Visita")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        saveVisitRecord()
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
    
    private func saveVisitRecord() {
        let record = VisitRecord(
            timestamp: Date(),
            managerStatus: managerStatus,
            paymentMethod: selectedPaymentMethod,
            paymentTermDays: paymentTermDays,
            paymentDueDate: Calendar.current.date(byAdding: .day, value: paymentTermDays, to: Date()),
            isPaid: isPaid,
            notes: notes,
            routeStop: stop
        )
        modelContext.insert(record)
        
        for (productID, qty) in productQuantities where qty > 0 {
            if let product = availableProducts.first(where: { $0.id == productID }) {
                let effectivePrice = product.price(for: selectedPriceTable)
                let item = TransactionItem(
                    itemType: visitPurpose,
                    quantity: qty,
                    unitPrice: effectivePrice,
                    product: product,
                    visitRecord: record
                )
                modelContext.insert(item)
            }
        }
        
        if managerStatus == .managerAbsent {
            stop.status = .managerAbsent
            if let storeName = stop.store?.name {
                NotificationManager.shared.scheduleManagerFollowUp(storeName: storeName, date: reminderDate)
            }
        } else {
            stop.status = .visited
        }
        stop.visitedAt = Date()
        
        try? modelContext.save()
        HapticManager.shared.notification(.success)
    }
}

@available(iOS 17.0, *)
private struct ProductQuantityRowView: View {
    let product: Product
    let storePriceTable: PriceTable?
    let quantity: Int
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
    var body: some View {
        let effectivePrice = product.price(for: storePriceTable)
        
        HStack {
            VStack(alignment: .leading) {
                Text(product.name).font(.body)
                HStack(spacing: 4) {
                    if effectivePrice > 0 {
                        Text(effectivePrice.formattedAsBRL() + " / " + product.unit)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        if effectivePrice != product.basePrice && product.basePrice > 0 {
                            Text("(De: \(product.basePrice.formattedAsBRL()))")
                                .font(.caption2)
                                .strikethrough()
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text("Sem preço (" + product.unit + ")")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
            Spacer()
            HStack(spacing: 12) {
                Button(action: onDecrement) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
                
                Text("\(quantity)")
                    .font(.headline)
                    .frame(minWidth: 24)
                
                Button(action: onIncrement) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
#endif
