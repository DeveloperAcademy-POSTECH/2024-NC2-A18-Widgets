//
//  ContentView.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/19/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(LocationManager.self) var locationManager: LocationManager
    
    var body: some View {
        VStack {
            if locationManager.isAuthorized {
                HomeView()
            } else {
                LocationDeniedView()
            }
        }
    }
}

