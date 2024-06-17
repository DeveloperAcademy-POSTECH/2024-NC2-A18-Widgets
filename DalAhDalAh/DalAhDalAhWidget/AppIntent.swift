//
//  AppIntent.swift
//  DalAhDalAhWidget
//
//  Created by 이종선 on 6/17/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Character", default: "duck")
    var favoriteCharacter: String
}

