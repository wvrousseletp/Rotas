import AppIntents
import Foundation

@available(iOS 17.0, *)
public struct CompleteStopIntent: AppIntent {
    public static var title: LocalizedStringResource = "Concluir Próxima Parada"
    public static var description = IntentDescription("Conclui a parada atual na rota de entregas ativas.")
    
    @Parameter(title: "ID da Parada")
    public var stopID: String?
    
    public init() {}
    
    public init(stopID: String) {
        self.stopID = stopID
    }
    
    public func perform() async throws -> some IntentResult {
        // AppIntent execution logic when triggered from Widget button
        return .result()
    }
}
