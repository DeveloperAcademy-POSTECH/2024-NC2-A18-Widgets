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
        var progress: Double // 월식의 진행현황을 ProgressView로 표현시 Value로 주려고 했던 값
        var currentTime: Date // 현재 시각을 보여주기 위해 사용해려고 했던 값
    }

    // LiveActivity에서 표시할 정보중 정적인 값들은
    // ActivityAttributes property를 통해 관리합니다.
    var eclipseStartTime: Date
    var eclipseEndTime: Date
    var eclipseMaxTime: Date
}


// 잠금화면에 대한 LiveActivity를 구성하는 View
struct DynamicAtivityForLockScreen: View {
    
    // LiveActivity에 대한 화면을 구성시
    // context를 통해 Attributes에서 정의한 property들 값을 사용할 수 있습니다.
    let context: ActivityViewContext<EclipseAttributes>
    
    var body: some View {
        
        // attributes값을 통해 월식의 시작과 끝시간의 범위를 지정할 수 있습니다.
        let timeRange : ClosedRange<Date> =
        context.attributes.eclipseStartTime ... context.attributes.eclipseEndTime
        
        // 잠금화면 LiveActivity의 최대 높이 값은 220 pixels 입니다.
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
                
                // 동적값도 실시간으로 업데이트해서 보여주는 것은 가능 (앱이 포어그라운드 상태일때)
               // Text(context.state.currentTime.toString(format: "HH:mm:ss"))
                
                HStack(spacing: 8){
                    
                    Text("\(context.attributes.eclipseStartTime.toString(format: "HH:mm"))")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    // 아래의 ProgressView를 통해 값을 동적으로 업데이트 하지 않아도 View내에서의 progress 값의 변경이 가능합니다. 
                    ProgressView(timerInterval: timeRange, countsDown: false) {
                        
                    } currentValueLabel: {
                        Text("")
                    }
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
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
        .activityBackgroundTint(Color.clear.opacity(0.1)) // 뒷배경 비침
    }
}

struct ExpandedTrailingView : View {
    
    var body: some View{
        
        Image("moon")
            .resizable()
            .frame(width: 61, height: 30)
            .padding(.top, 7)
            .padding(.trailing, 20)
    }
}

struct ExpandedBottomView: View {
    
    let context: ActivityViewContext<EclipseAttributes>
    
    var body: some View {
        
        // ProgressView의 timeInterval 인자에 대한 값을 설정
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
}

struct CompactLeadingView: View {
    var body: some View {
        Image("여우머리")
            .resizable()
            .frame(width: 23, height: 23)
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
        // LiveActivity에 필요한 데이터를 구성하고 있는 Attributes 클로저를 통해 context로 넘겨주고
        // 각 View에서 context를 통해 해당 값에 접근할 수 있습니다.
        ActivityConfiguration(for: EclipseAttributes.self) { context in
            // Lock screen/banner 에대한 UI는 여기에 정의
            DynamicAtivityForLockScreen(context: context)
            
        } dynamicIsland: { context in
            // DynamicIsland에 대한 UI는 여기에 정의
            DynamicIsland {
                // DynamicIsland를 꾹 눌렀을 때 확장되는 영역에 대한 정의
                DynamicIslandExpandedRegion(.leading) {
                   // 왼쪽 상단 area
                    
                }
                DynamicIslandExpandedRegion(.trailing) {
                    // 오른쪽 상단 area
                    ExpandedTrailingView()

                }
                DynamicIslandExpandedRegion(.bottom) {
                    // 아래쪽 area
                    ExpandedBottomView(context: context)
                   
                }
                
                
            } compactLeading: {
                // 다이나믹 아이랜드 센서부기준 왼쪽
                CompactLeadingView()
            } compactTrailing: {
                // 다이나믹 아이랜드 센서부기준 오른쪽
                CompactTrailingView(context: context)
            } minimal: {
                CompactLeadingView()
            }
            .widgetURL(URL(string: "http://www.apple.com")) // Link type을 활용하여 해당 위젯을 눌렀을 때 앱내의 원하는 위치로 사용자를 direct
            .keylineTint(Color("ring"))  // dynamic island 주변부의 색을 결정
        }
    }
}

// extension을 통하여 다음과 같이 preview를 위한 Attributes와 ContentState를 정의해서 활용할 수 있습니다. 
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


