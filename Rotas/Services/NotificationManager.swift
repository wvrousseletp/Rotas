import Foundation
import UserNotifications

public final class NotificationManager {
    public static let shared = NotificationManager()
    
    private init() {}
    
    public func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    public func scheduleManagerFollowUp(storeName: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Revisitar Mercado: \(storeName)"
        content.body = "O gerente comercial não estava presente na última visita. Lembre-se de passar novamente no local."
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "followup-\(storeName)-\(date.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    public func schedulePaymentDueDateReminder(storeName: String, amount: Double, dueDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Vencimento de Consignação / Venda"
        content.body = "O valor de \(amount.formattedAsBRL()) do local '\(storeName)' vence hoje."
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "payment-\(storeName)-\(dueDate.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
