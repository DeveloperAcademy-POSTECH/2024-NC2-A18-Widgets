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
    
    // LiveActivity에서 실시간으로 변경되어야하는 값들은
    // ActivityAttributes 내부의 ContentState를 통해 관리합니다.
    public struct ContentState: Codable, Hashable {
        /// Activity의 동적값들
        /// MARK: ProgressView를 closedRange를 통해 처리해서  현재 다이나믹 activity의 화면을
        /// 표시할 때 동적 정보를 표시하는게 없습니다.
        /// 기존에는 progressView의 value 값과 현재시각을 표시하기 위해 ContentState를 선언 하였으나
        /// 앱이 Foreground에 없으면 값의 업데이트가 중지되는 현상의 발견하여
        /// ProgressView의 init 중 closedRange value를 받아 값 업데이트를 View 내부에서 진행하는 방식을 선택
        var progress: Double
        var currentTime: Date
    }

    // LiveActivity에서 표시할 정보중 정적인 값들은
    // ActivityAttributes property를 통해 관리합니다.
    var eclipseStartTime: Date
    var eclipseEndTime: Date
    var eclipseMaxTime: Date
}


// 잠금화면에 대한 LiveActivity를 구성하는 View
struct DynamicAtivityForLockScreen: View {
    
    let context: ActivityViewContext<EclipseAttributes>
    var body: some View {
        let timeRange : ClosedRange<Date> =
        context.attributes.eclipseStartTime ... context.attributes.eclipseEndTime
        
        // Live Activity Max Height 220 pixels
        ZStack{
            
            LinearGradient(colors: [Color("color2").opacity(0.5), Color("color1")], startPoint: .top, endPoint: .bottom)
            
            Image("star")
                .resizable()
                .frame(width: 327, height: 43)
                .offset(y: -45)
            
            
            Image("여우 벡터")
                .resizable()
                .frame(width: 226, height: 160)
                .shadow(color: .white, radius: 20)
            
            LinearGradient(colors: [Color("foreground").opacity(0),Color("foreground").opacity(0),Color("foreground").opacity(0),Color("foreground")], startPoint: .top, endPoint: .bottom)
            
            
            VStack(spacing: 12){
                
                HStack(spacing: 8){
                    
                    Text("\(context.attributes.eclipseStartTime.toString(format: "HH:mm"))")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    
                    ProgressView(timerInterval: timeRange,countsDown: false) {
                        
                    } currentValueLabel: {
                        Text("")
                    }
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    //.scaleEffect(x: 1, y: 3)
                    .offset(y: 10)
                    
                    
                    Text("\(context.attributes.eclipseEndTime.toString(format: "HH:mm"))")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
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
            Text("")
        }
        .progressViewStyle(CircularProgressViewStyle(tint: Color("ring")))
        .foregroundStyle(.yellow)
        
        
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
                   
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image("moon")
                        .resizable()
                        .frame(width: 61, height: 30)
                        .padding(.top, 7)
                        .padding(.trailing, 20)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    let timeRange : ClosedRange<Date> =
                    context.attributes.eclipseStartTime ... context.attributes.eclipseEndTime
                    
                    VStack(alignment: .leading, spacing: 2){
                        HStack(spacing:6){
                            Text("지금은 소원을 빌 시간")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Image("여우하얀머리")
                                .resizable()
                                .frame(width: 16, height: 16)
                            
                        }
                        
                        HStack(spacing: 8){
                            
                            Text("\(context.attributes.eclipseStartTime.toString(format: "HH:mm"))")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                            
                            
                            ProgressView(timerInterval: timeRange,countsDown: false) {
                                
                            } currentValueLabel: {
                                Text("")
                            }
                            .progressViewStyle(LinearProgressViewStyle(tint: .white))
                            .offset(y: 10)
                            .frame(maxWidth: 240)
                            
                            
                            Text("\(context.attributes.eclipseEndTime.toString(format: "HH:mm"))")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                            
                        }
                        
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, -14)
                    .offset(y: -14)
                }
                
                
            } compactLeading: {
                Image("여우머리")
                    .resizable()
                    .frame(width: 23, height: 23)
                
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


extension Date{
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
