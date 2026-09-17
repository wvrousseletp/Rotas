import WidgetKit
import SwiftUI
import AppIntents

struct SimpleRouteEntry: TimelineEntry {
    let date: Date
    let routeTitle: String
    let currentStoreName: String
    let completedStops: Int
    let totalStops: Int
}

struct RouteWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleRouteEntry {
        SimpleRouteEntry(date: Date(), routeTitle: "Rota Zona Sul", currentStoreName: "Supermercado Bonfim", completedStops: 3, totalStops: 8)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleRouteEntry) -> ()) {
        let entry = SimpleRouteEntry(date: Date(), routeTitle: "Rota Zona Sul", currentStoreName: "Supermercado Bonfim", completedStops: 3, totalStops: 8)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleRouteEntry>) -> ()) {
        let entry = SimpleRouteEntry(date: Date(), routeTitle: "Rota Ativa", currentStoreName: "Próximo Local", completedStops: 1, totalStops: 5)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct ActiveRouteWidgetEntryView: View {
    var entry: RouteWidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "map.fill")
                    .foregroundColor(.blue)
                Text(entry.routeTitle)
                    .font(.caption)
                    .bold()
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(entry.completedStops)/\(entry.totalStops)")
                    .font(.caption2)
                    .bold()
            }
            
            Text(entry.currentStoreName)
                .font(.headline)
                .lineLimit(1)
            
            Spacer()
            
            if #available(iOS 17.0, *) {
                Button(intent: CompleteStopIntent()) {
                    Label("Concluir Visita", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(UIColor.systemBackground)
        }
    }
}

public struct ActiveRouteWidget: Widget {
    let kind: String = "ActiveRouteWidget"

    public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RouteWidgetProvider()) { entry in
            ActiveRouteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Rota Ativa")
        .description("Acompanhe o progresso da sua rota de visitas ao vivo.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
