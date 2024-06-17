//
//  DalAhDalAhWidgetLiveActivity.swift
//  DalAhDalAhWidget
//
//  Created by 이종선 on 6/17/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DalAhDalAhWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DalAhDalAhWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DalAhDalAhWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DalAhDalAhWidgetAttributes {
    fileprivate static var preview: DalAhDalAhWidgetAttributes {
        DalAhDalAhWidgetAttributes(name: "World")
    }
}

extension DalAhDalAhWidgetAttributes.ContentState {
    fileprivate static var smiley: DalAhDalAhWidgetAttributes.ContentState {
        DalAhDalAhWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DalAhDalAhWidgetAttributes.ContentState {
         DalAhDalAhWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DalAhDalAhWidgetAttributes.preview) {
   DalAhDalAhWidgetLiveActivity()
} contentStates: {
    DalAhDalAhWidgetAttributes.ContentState.smiley
    DalAhDalAhWidgetAttributes.ContentState.starEyes
}
