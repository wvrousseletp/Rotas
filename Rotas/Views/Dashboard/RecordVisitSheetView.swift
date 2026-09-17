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
                
                Section(header: Text("Produtos Deixados / Vendidos")) {
                    if availableProducts.isEmpty {
                        Text("Nenhum produto cadastrado no catálogo.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(availableProducts) { product in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(product.name).font(.body)
                                    Text(product.basePrice.formattedAsBRL() + " / " + product.unit)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                HStack(spacing: 12) {
                                    Button(action: {
                                        let current = productQuantities[product.id] ?? 0
                                        if current > 0 {
                                            productQuantities[product.id] = current - 1
                                            HapticManager.shared.impact(.light)
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Text("\(productQuantities[product.id] ?? 0)")
                                        .font(.headline)
                                        .frame(minWidth: 24)
                                    
                                    Button(action: {
                                        let current = productQuantities[product.id] ?? 0
                                        productQuantities[product.id] = current + 1
                                        HapticManager.shared.impact(.light)
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(.green)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
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
                        Stepper("Prazo: \(paymentTermDays) dias", value: $paymentTermDays, in: 0...90, step: 5)
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
                let item = TransactionItem(
                    itemType: visitPurpose,
                    quantity: qty,
                    unitPrice: product.basePrice,
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
#endif
