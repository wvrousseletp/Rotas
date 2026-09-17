import SwiftUI

#if canImport(SwiftData)
import SwiftData

@available(iOS 17.0, *)
public struct ClientStoreDetailView: View {
    let store: ClientStore
    
    public var body: some View {
        List {
            Section(header: Text("Informações Gerais")) {
                LabeledContent("Nome / Razão Social", value: store.name)
                if let trade = store.tradeName {
                    LabeledContent("Nome Fantasia", value: trade)
                }
                LabeledContent("Categoria", value: store.category.rawValue)
                LabeledContent("Endereço", value: store.address)
            }
            
            Section(header: Text("Contato Comercial")) {
                if let contact = store.contactName {
                    LabeledContent("Gerente / Comprador", value: contact)
                } else {
                    Text("Nenhum contato cadastrado.").foregroundColor(.secondary)
                }
                if let phone = store.contactPhone {
                    LabeledContent("Telefone / WhatsApp", value: phone)
                }
            }
            
            if let notes = store.notes {
                Section(header: Text("Observações")) {
                    Text(notes).font(.subheadline)
                }
            }
        }
        .navigationTitle(store.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
#endif
