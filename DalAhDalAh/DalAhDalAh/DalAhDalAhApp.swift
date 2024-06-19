//
//  DalAhDalAhApp.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/16/24.
//

import SwiftUI

@main
struct DalAhDalAhApp: App {
    @State private var eclipseHelper = EclipseHelper()
    @State private var locationManager = LocationManager()
    //@StateObject private var lNManager = LocalNotificationManager()
    
    var body: some Scene {
        WindowGroup {    
            ContentView()
                .onAppear{
                    locationManager.startLocationServices()
                }
        }
        .environment(eclipseHelper)
        .environment(locationManager)
      //  .environmentObject(lNManager)
    }
}
