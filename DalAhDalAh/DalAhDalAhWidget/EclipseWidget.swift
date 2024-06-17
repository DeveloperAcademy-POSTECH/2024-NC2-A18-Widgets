//
//  DalAhDalAhWidget.swift
//  DalAhDalAhWidget
//
//  Created by 이종선 on 6/17/24.
//

import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {

    // 이 메서드는 위젯이 아직 데이터를 로드하지 않았을 때 표시할 기본 뷰를 제공합니다. 빠르게 로드되며, 임시 데이터를 사용
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), daysUntilEclipse: 0, moonPhase: "🌕", configuration: ConfigurationAppIntent())
    }

    // 이 메서드는 위젯 갤러리에서 또는 빠른 미리보기가 필요할 때 호출됩니다. 현재 상태의 스냅샷을 제공
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        return SimpleEntry(date: Date(), daysUntilEclipse: calculateDaysUntilNextEclipse(), moonPhase: getCurrentMoonPhase(), configuration: ConfigurationAppIntent())
        
    }
    
    // 위젯에 표시할 정보 업데이트를 위한 메서드
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // 자정 시점을 계산
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentDate)
        let nextUpdateDate = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        // 엔트리 생성
        let entry = SimpleEntry(date: nextUpdateDate, daysUntilEclipse: calculateDaysUntilNextEclipse(), moonPhase: getCurrentMoonPhase(), configuration: ConfigurationAppIntent())
        entries.append(entry)
        
        // 타임라인 생성
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        return timeline
    }

    
    private func calculateDaysUntilNextEclipse() -> Int? {
        let now = Date()
        guard let nextEclipse = EclipseDataManager.shared.getNextEclipse(from: now) else {
            return nil
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: now, to: nextEclipse.startDateTime!)
        return components.day
    }
    
    private func getCurrentMoonPhase() -> String {
        // 달의 모양을 결정하는 로직을 여기에 추가
        // 여기서는 예시로 특정 이모티콘을 반환
        return "🌕"
    }
}

// 위젯을 구성할 데이터가진 struct
struct SimpleEntry: TimelineEntry {
    let date: Date
    let daysUntilEclipse: Int?
    let moonPhase: String
    let configuration: ConfigurationAppIntent
}


struct SmallEclipseWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if let daysUntilEclipse = entry.daysUntilEclipse {
                Text("Next eclipse in \(daysUntilEclipse) days")
                    .font(.headline)
            } else {
                Text("No upcoming eclipse")
                    .font(.headline)
            }
        }
    }
}

struct MediumEclipseWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            if let daysUntilEclipse = entry.daysUntilEclipse {
                VStack {
                    Text("Next eclipse in \(daysUntilEclipse) days")
                        .font(.headline)
                    Text(entry.moonPhase)
                        .font(.largeTitle)
                }
            } else {
                Text("No upcoming eclipse")
                    .font(.headline)
            }
        }
    }
}

struct LargeEclipseWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if let daysUntilEclipse = entry.daysUntilEclipse {
                Text("Next eclipse in \(daysUntilEclipse) days")
                    .font(.headline)
                Text(entry.moonPhase)
                    .font(.largeTitle)
            } else {
                Text("No upcoming eclipse")
                    .font(.headline)
            }
           
        }
    }
}


struct AccessoryCircularEclipseWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Circle().fill(Color.blue)
            if let daysUntilEclipse = entry.daysUntilEclipse {
                Text("\(daysUntilEclipse)")
                    .font(.headline)
                    .foregroundColor(.white)
            } else {
                Text("N/A")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

struct AccessoryRectangularEclipseWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            if let daysUntilEclipse = entry.daysUntilEclipse {
                Text("Eclipse in \(daysUntilEclipse) days")
                    .font(.headline)
            } else {
                Text("No upcoming eclipse")
                    .font(.headline)
            }
        }
    }
}

struct AccessoryInlineEclipseWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        if let daysUntilEclipse = entry.daysUntilEclipse {
            Text("Eclipse in \(daysUntilEclipse) days")
        } else {
            Text("No upcoming eclipse")
        }
    }
}

struct EclipseWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallEclipseWidgetView(entry: entry)
        case .systemMedium:
            MediumEclipseWidgetView(entry: entry)
        case .systemLarge:
            LargeEclipseWidgetView(entry: entry)
        case .accessoryCircular:
            AccessoryCircularEclipseWidgetView(entry: entry)
        case .accessoryRectangular:
            AccessoryRectangularEclipseWidgetView(entry: entry)
        case .accessoryInline:
            AccessoryInlineEclipseWidgetView(entry: entry)
        default:
            SmallEclipseWidgetView(entry: entry)
        }
    }
}


struct EclipseWidget: Widget {
    let kind: String = "DalADalAWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            EclipseWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Eclipse Widget")
        .description("Shows the days until the next eclipse and the current moon phase.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge,  .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

// 사용자가 설정할 수 있는 emoji의 종류를 지정
extension ConfigurationAppIntent {
    fileprivate static var duck: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteCharacter = "duck"
        return intent
    }
    
    fileprivate static var fineapple: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteCharacter = "fineapple"
        return intent
    }
}


struct EclipseWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EclipseWidgetEntryView(entry: SimpleEntry(date: Date(), daysUntilEclipse: 5, moonPhase: "🌕", configuration: ConfigurationAppIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            EclipseWidgetEntryView(entry: SimpleEntry(date: Date(), daysUntilEclipse: 5, moonPhase: "🌕", configuration: ConfigurationAppIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            EclipseWidgetEntryView(entry: SimpleEntry(date: Date(), daysUntilEclipse: 5, moonPhase: "🌕", configuration: ConfigurationAppIntent()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))

            EclipseWidgetEntryView(entry: SimpleEntry(date: Date(), daysUntilEclipse: 5, moonPhase: "🌕", configuration: ConfigurationAppIntent()))
                .previewContext(WidgetPreviewContext(family: .systemExtraLarge))

            EclipseWidgetEntryView(entry: SimpleEntry(date: Date(), daysUntilEclipse: 5, moonPhase: "🌕", configuration: ConfigurationAppIntent()))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))

            EclipseWidgetEntryView(entry: SimpleEntry(date: Date(), daysUntilEclipse: 5, moonPhase: "🌕", configuration: ConfigurationAppIntent()))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))

            EclipseWidgetEntryView(entry: SimpleEntry(date: Date(), daysUntilEclipse: 5, moonPhase: "🌕", configuration: ConfigurationAppIntent()))
                .previewContext(WidgetPreviewContext(family: .accessoryInline))
        }
    }
}
