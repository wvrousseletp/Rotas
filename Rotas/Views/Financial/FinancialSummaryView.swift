import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct FinancialSummaryView: View {
    @Query private var visitRecords: [VisitRecord]
    
    private var pendingPayments: [VisitRecord] {
        visitRecords.filter { !$0.isPaid && $0.totalAmount > 0 }
    }
    
    private var totalPendingAmount: Double {
        pendingPayments.reduce(0.0) { $0 + $1.totalAmount }
    }
    
    private var totalPaidAmount: Double {
        visitRecords.filter { $0.isPaid }.reduce(0.0) { $0 + $1.totalAmount }
    }
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("A Receber").font(.caption).foregroundColor(.secondary)
                        Text(totalPendingAmount.formattedAsBRL()).font(.title2).bold().foregroundColor(.orange)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Recebido").font(.caption).foregroundColor(.secondary)
                        Text(totalPaidAmount.formattedAsBRL()).font(.title2).bold().foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Valores e Consignações Pendentes")
                        .font(.headline)
                        .padding(.horizontal, 4)
                    
                    if pendingPayments.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.green)
                            Text("Nenhum pagamento pendente!").font(.headline)
                            Text("Todas as vendas e entregas consignadas estão em dia.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(16)
                    } else {
                        ForEach(pendingPayments) { record in
                            PendingPaymentRowView(record: record)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Financeiro & Prazos")
    }
}

@available(iOS 17.0, *)
struct PendingPaymentRowView: View {
    @Environment(\.modelContext) private var modelContext
    let record: VisitRecord
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.routeStop?.store?.name ?? "Ponto de Venda").font(.headline)
                if let dueDate = record.paymentDueDate {
                    Text("Vencimento: \(dueDate.formattedShortDate()) (\(record.paymentTermDays) dias)")
                        .font(.caption)
                        .foregroundColor(dueDate < Date() ? .red : .secondary)
                }
                Text("Forma: \(record.paymentMethod.rawValue)").font(.caption2).foregroundColor(.blue)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Text(record.totalAmount.formattedAsBRL()).font(.headline).foregroundColor(.orange)
                Button(action: {
                    record.isPaid = true
                    try? modelContext.save()
                    HapticManager.shared.notification(.success)
                }) {
                    Text("Dar Baixa")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}
#else
public struct FinancialSummaryView: View {
    public init() {}
    public var body: some View { Text("FinancialSummaryView requer iOS 17+") }
}
#endif
