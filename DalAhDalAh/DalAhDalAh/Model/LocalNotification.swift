//
//  LocalNotification.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/19/24.
//

import Foundation

struct LocalNotification {
    var id: String
    var title: String
    var body: String
    var timeInterval: Double? //for timeInterval trigger
    var dateComponent: DateComponents?  // for Calendar trigger
    var repeats: Bool
    
    // Intializer for calendar
    internal init(id: String, title: String, body: String, timeInterval: Double,repeats: Bool) {
        self.id = id
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponent = nil
        self.repeats = repeats
    }
    
    // Intitializer for calendar
    internal init(id: String, title: String, body: String, dateComponent: DateComponents, repeats: Bool) {
        self.id = id
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponent = dateComponent
        self.repeats = repeats
    }

}
