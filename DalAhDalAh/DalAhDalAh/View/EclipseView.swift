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
            
            if let eclipse = vm.eclipse {
                Text("Date: \(eclipse.date)")
                Text("Start Time: \(eclipse.startTime)")
                Text("End Time: \(eclipse.endTime)")
                Text("Max Time: \(eclipse.maxTime)")
                Text("Type: \(eclipse.type.rawValue)")
                
                if !vm.isActivityStarted {
                    Button("Start Eclipse Activity") {
                        vm.start()
                    }
                    .padding()
                } else {
                    Button("End Activity") {
                        vm.endActivity()
                    }
                    .padding()
                }
            } else {
                Text("No upcoming eclipse found")
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
