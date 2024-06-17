//
//  DalAhDalAhApp.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/16/24.
//

import SwiftUI

@main
struct DalAhDalAhApp: App {
    @State private var vm = EclipseViewModel()
    
    var body: some Scene {
        WindowGroup {
            EclipseView()
        }
        .environment(vm)
    }
}
