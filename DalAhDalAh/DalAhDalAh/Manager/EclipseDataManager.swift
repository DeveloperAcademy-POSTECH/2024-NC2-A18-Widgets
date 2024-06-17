//
//  File.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/17/24.
//

import Foundation

class EclipseDataManager {
    
    static let shared = EclipseDataManager()
    
    private init(){}
    
    func loadEclipseData() -> [Eclipse] {
        
        guard let url = Bundle.main.url(forResource: "eclipses", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([Eclipse].self, from: data)
        } catch {
            print("Error loading or parsing JSON: \(error)")
            return []
        }
    }
    
    func getNextEclipse(from date: Date) -> Eclipse? {
           let eclipses = loadEclipseData()
        return eclipses
               .filter { $0.startDateTime != nil }
               .filter { $0.startDateTime! > date }
               .sorted { $0.startDateTime! < $1.startDateTime! }
               .first
       }
}
