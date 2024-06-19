//
//  HomeView.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/19/24.
//

import SwiftUI
import WeatherKit

struct HomeView : View {
    
    @Environment(LocationManager.self) var locationManager
    @State private var selectedCity: City?
    @State private var isLoading = false
    @State private var moonPhase: MoonPhase?
    
    var body : some View {
        
        VStack{
            
            EclipseView()
            
            if let selectedCity {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Text(selectedCity.name)
                        .font(.title)
                  
                    moonPhaseView(moonPhase: moonPhase)
                }
            }
            
        }
        .task(id: locationManager.currentLocation) {
            if let currentLocation = locationManager.currentLocation, selectedCity == nil {
                selectedCity = currentLocation
            }
            
        }
        .task(id: selectedCity) {
            if let selectedCity {
                await getMoonPhase(city: selectedCity)
            }
        }
        
    }
    
    @ViewBuilder
    func moonPhaseView(moonPhase: MoonPhase?) -> some View {
        
        switch moonPhase {
        case .new:
            Text("초승달")
                .font(.largeTitle)
        case .waxingCrescent:
            Text("상현달")
                .font(.largeTitle)
        case .firstQuarter:
            Text("반달")
                .font(.largeTitle)
        case .waxingGibbous:
            Text("상현둥근달")
                .font(.largeTitle)
        case .full:
            Text("보름달")
                .font(.largeTitle)
        case .waningGibbous:
            Text("하현둥근달")
                .font(.largeTitle)
        case .lastQuarter:
            Text("하현달")
                .font(.largeTitle)
        case .waningCrescent:
            Text("그믐달")
                .font(.largeTitle)
        case nil:
            Text("알 수 없는 상태")
                .font(.largeTitle)
        }
    }
    
    func getMoonPhase(city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            let dayWeather = await WeatherManager.shared.currentWeather(for: city.clLocation)
            moonPhase = dayWeather?.dailyForecast.forecast.first?.moon.phase
        }
        isLoading = false
    }
}
