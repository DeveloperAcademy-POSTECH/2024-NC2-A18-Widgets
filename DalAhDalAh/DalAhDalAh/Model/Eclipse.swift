//
//  Eclipse.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/17/24.
//

import Foundation

struct Eclipse: Identifiable, Codable {
    
    var id: String = UUID().uuidString
    var date: String
    var startTime: String
    var endTime: String
    var maxTime: String
    var type: EclipseType
    
    enum CodingKeys: String, CodingKey {
        case date
        case startTime
        case endTime
        case maxTime
        case type
    }
    
    var dateObject: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date)
    }
    
    var startDateTime: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: "\(date) \(startTime)")
    }
    
    var endDateTime: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: "\(date) \(endTime)")
    }
    
    var maxDateTime: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: "\(date) \(maxTime)")
    }
    
    var imageName: String {
        return "eclipse_\(date.replacingOccurrences(of: "-", with: "_"))"
        
    }
    
}

// MARK: 달이 본그림자에 들어갔을 경우만 다루는 일식의 범위에 들어감
enum EclipseType: String, Codable {
    case total = "Total Lunar Eclipse"
    case partial = "Partial Lunar Eclipse"
}

