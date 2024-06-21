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
    
        VStack (alignment:.center,spacing:0){
                if let daysUntilEclipse = entry.daysUntilEclipse {
                    
                    VStack(spacing: 0){
                        ZStack{
                            
                            Image("별")
                                .resizable()
                                .frame(width: 131, height: 41)
                                .offset(y: -18)
                            
                            Image("달")
                                .resizable()
                                .frame(width: 56, height: 56)
                            
                        }
                        
                        VStack(spacing: 2){
                          
                            Text("다음 소원까지")
                                .font(.subheadline)
                                .fontWeight(.regular)
                            
                            
                            Text("\(daysUntilEclipse)일")
                                .font(.title3)
                                .fontWeight(.semibold)
                                
                        }
                        .padding(.top,12)
                        .foregroundStyle(.white)
                    }
                    
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
            Image("Vector")
                .resizable()
                .frame(width: 52, height: 53)
            
            if let daysUntilEclipse = entry.daysUntilEclipse {
                Text("\(daysUntilEclipse)")
                    .font(.system(size: 16))
                    .bold()
                    .foregroundStyle(
                        Color.black.shadow(.inner(color: .white.opacity(0.5),radius: 2)))
                    .offset(y: 8)

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
                .containerBackground(for: .widget){
                    LinearGradient(colors: [Color("widgetback"), Color("widgetback2")], startPoint: .top, endPoint: .bottom)
                }
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
