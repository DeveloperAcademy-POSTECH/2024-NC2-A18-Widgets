//
//  LocationDeniedView.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/19/24.
//

import SwiftUI


struct LocationDeniedView: View {
    var body: some View {
        ContentUnavailableView(label: { Label("위치 서비스", systemImage: "gear") },
                               description: {
            Text("""
1. 아래 버튼을 눌러 "개인 정보 보호 및 보안"으로 이동하세요
2. "위치 서비스"를 누르세요
3. "MyWeather" 앱을 찾아 누르세요
4. 설정을 "앱 사용 중"으로 변경하세요
""").multilineTextAlignment(.leading)
        },
                               actions: {
            Button(action: {
                UIApplication.shared.open(
                    URL(string: UIApplication.openSettingsURLString)!,
                    options: [:],
                    completionHandler: nil
                )
                
            }) {
                Text("설정 열기")
            }
            .buttonStyle(.borderedProminent)
        })
    }
}

#Preview {
    LocationDeniedView()
}
