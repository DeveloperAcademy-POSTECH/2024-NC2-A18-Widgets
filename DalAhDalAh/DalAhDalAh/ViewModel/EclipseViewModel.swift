//
//  EclipseViewModel.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/17/24.
//
import ActivityKit
import SwiftUI

@Observable
class EclipseViewModel {
    
    var eclipse: Eclipse?
    var isActivityStarted = false
    private var activity: Activity<EclipseAttributes>?
    private var timer: Timer?
    
    init() {
        print("toddasfsdfjlasdjf")
        //loadNextEclipse()
        // MARK: 현재 임시 데이터로 progress 진행상태를 실시간으로 보여주고 있음
        loadTemporaryEclipseData()
    }
    
    func loadTemporaryEclipseData() {
        // progress 진행상태를 실시간으로 보여줄 수 있는 임시 데이터
        let now = Date()
        let startTime = now.addingTimeInterval(5)
        let endTime = now.addingTimeInterval(60)
        let maxTime = now.addingTimeInterval(20)

        let temporaryEclipse = Eclipse(
            id: UUID().uuidString,
            date: dateFormatter.string(from: now),
            startTime: timeFormatter.string(from: startTime),
            endTime: timeFormatter.string(from: endTime),
            maxTime: timeFormatter.string(from: maxTime),
            type: .total
        )

        self.eclipse = temporaryEclipse
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }

    func loadNextEclipse() {
        if let nextEclipse = EclipseDataManager.shared.getNextEclipse(from: Date()) {
            self.eclipse = nextEclipse
        }
    }

    func startEclipseActivity() {
        guard let eclipse = eclipse,
              let startTime = eclipse.startDateTime,
              let endTime = eclipse.endDateTime,
              let maxTime = eclipse.maxDateTime else {
            return
        }

        // 정적값 설정
        let initialAttributes = EclipseAttributes(
            eclipseStartTime: startTime,
            eclipseEndTime: endTime,
            eclipseMaxTime: maxTime
        )
        
        // 동적 값 설정
        let initialContentState = EclipseAttributes.ContentState(
            progress: 0.0,
            currentTime: Date()
        )
        
        // staleDate 더이상 LivActivity가 유효하지 않은 시점을 나타냄
        let staleDate = endTime.addingTimeInterval(60 * 5) // endTime으로부터 5분 후
        // acitivity에 관련한 동적 데이터는 ActivityContent라는 wrapper 싸서 넣어줘야함
        let activityContent = ActivityContent(state: initialContentState, staleDate: staleDate)
        
        do {
            let activity = try Activity<EclipseAttributes>.request(
                attributes: initialAttributes,
                content: activityContent,
                pushType: nil
            )
            self.activity = activity
            self.isActivityStarted = true
            startTimer()
        } catch {
            print("Failed to start activity: \(error)")
        }
    }
    
    func startTimer() {
        timer?.invalidate() // 이미 활성화되어있는 timer가 있는지 확인해서 끄고 새로운 타이머를 시작
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateEclipseActivity()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func updateEclipseActivity() {
        
        guard let activity = activity,
              let eclipse = eclipse,
              let startTime = eclipse.startDateTime,
              let endTime = eclipse.endDateTime else { return }

        let currentTime = Date()
        let elapsed = currentTime.timeIntervalSince(startTime)
        let duration = endTime.timeIntervalSince(startTime)
        var progress = elapsed / duration
        progress = min(max(progress, 0.0), 1.0)

        let updatedContentState = EclipseAttributes.ContentState(
            progress: progress,
            currentTime: currentTime
        )
        
        let staleDate = eclipse.endDateTime?.addingTimeInterval(60 * 5) ?? Date().addingTimeInterval(60 * 5)
        let activityContent = ActivityContent(state: updatedContentState, staleDate: staleDate)
        
        Task {
            // AcitivityKit에 update
            await activity.update(activityContent)
        }
        
        if currentTime >= endTime {
            endEclipseActivity()
        }
    }
    
    func endEclipseActivity() {
        guard let activity = activity else { return }

        let finalContentState = EclipseAttributes.ContentState(
            progress: 1.0,
            currentTime: Date()
        )
        
        let staleDate = Date().addingTimeInterval(60 * 5)
        let activityContent = ActivityContent(state: finalContentState, staleDate: staleDate)

        Task {
            await activity.end(activityContent, dismissalPolicy: .immediate)
        }
        
        stopTimer()
    }
}
