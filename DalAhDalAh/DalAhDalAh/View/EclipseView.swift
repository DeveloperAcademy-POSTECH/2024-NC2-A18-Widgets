//
//  EclipseView.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/17/24.
//

import SwiftUI

struct EclipseView: View {
    
    @Environment(EclipseViewModel.self) var vm: EclipseViewModel

    var body: some View {
        
        VStack {
            Text("Eclipse Tracker")
                .font(.largeTitle)
            
            Button("Start Eclipse Activity"){
                vm.start()
            }
            Button("Update Activity"){
                vm.updateLiveActivity()
            }
            Button("End Activity"){
                vm.endActivity()
            }
        }
        .padding()
        .onAppear {
            // MARK: 개발 단계에서는 progress UI확인을위해 일단 주석처리
            // vm.loadNextEclipse()
        }
    }
}


#Preview {
    EclipseView()
}
