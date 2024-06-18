//
//  DalAhDalAhWidgetLiveActivity.swift
//  DalAhDalAhWidget
//
//  Created by 이종선 on 6/17/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct EclipseAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        // MARK: ProgressView를 closedRange를 통해 처리해서  현재 다이나믹 activity에 대해 동적정보값을 사용하는게 없음
        var progress: Double
        var currentTime: Date
    }

    // Fixed non-changing properties about your activity go here!
    var eclipseStartTime: Date
    var eclipseEndTime: Date
    var eclipseMaxTime: Date
}


// Dynamic Activity View for Lock Screen
struct DynamicAtivityForLockScreen: View {
    let context: ActivityViewContext<EclipseAttributes>
    var body: some View {
        let timeRange : ClosedRange<Date> =
        context.attributes.eclipseStartTime ... context.attributes.eclipseEndTime
        
        // Live Activity Max Height 220 pixels
        ZStack{
            
            LinearGradient(colors: [Color("color2").opacity(0.5), Color("color1")], startPoint: .top, endPoint: .bottom)
            
            Image("fox")
                .resizable()
                .frame(width: 200, height: 150)
                
            
            LinearGradient(colors: [Color("color3").opacity(0),Color("color3").opacity(0), Color("color3").opacity(1.0)], startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 12){
                
                HStack(spacing: 4){
                    
                    Text(context.attributes.eclipseStartTime, style: .time)
                    
            
                    ProgressView(timerInterval: timeRange,countsDown: false) {
                        
                    } currentValueLabel: {
                        Text("")
                    }
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    //.scaleEffect(x: 1, y: 3)
                    .offset(y: 10)
                    
                    
                    Text(context.attributes.eclipseEndTime, style: .time)
                    
                }
                .font(.footnote)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                
                
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .bottom)


        }
        .activityBackgroundTint(Color.clear.opacity(0.1))
    }
}

struct CompactTrailingView : View {
    
    let context: ActivityViewContext<EclipseAttributes>
    var body: some View{
        
        let timeRange : ClosedRange<Date> =
        context.attributes.eclipseStartTime ... context.attributes.eclipseEndTime
        ProgressView(timerInterval: timeRange,countsDown: false) {
            
        } currentValueLabel: {
            Text("G")
        }
        .progressViewStyle(.circular)
        
        
    }
}


struct EclipseLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: EclipseAttributes.self) { context in
            // Lock screen/banner UI goes here
            DynamicAtivityForLockScreen(context: context)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                CompactTrailingView(context: context)
            } minimal: {
             
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension EclipseAttributes {
    fileprivate static var preview: EclipseAttributes {
       EclipseAttributes(eclipseStartTime: Date().addingTimeInterval(-3600),
                         eclipseEndTime: Date().addingTimeInterval(3600),
                         eclipseMaxTime: Date())
    }
}

extension EclipseAttributes.ContentState {
    fileprivate static var initial: EclipseAttributes.ContentState {
        EclipseAttributes.ContentState(progress: 0.5, currentTime: Date())
     }
     
     fileprivate static var final: EclipseAttributes.ContentState {
         EclipseAttributes.ContentState(progress: 1.0, currentTime: Date().addingTimeInterval(3600))
     }
}

#Preview("Notification", as: .content, using: EclipseAttributes.preview) {
   EclipseLiveActivity()
} contentStates: {
    EclipseAttributes.ContentState.initial
    EclipseAttributes.ContentState.final
}

