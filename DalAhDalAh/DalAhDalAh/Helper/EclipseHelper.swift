//
//  EclipseViewModel.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/17/24.
//
import ActivityKit
import SwiftUI

@Observable
class EclipseHelper {
    
    var eclipse: Eclipse?
    var isActivityStarted = false
    var activity: Activity<EclipseAttributes>?
    private var timer: Timer?
    @MainActor private(set) var activityID: String?
    
    init() {
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
            date: Date().toString(format: "yyyy-MM-dd"),
            startTime: startTime.toString(format: "HH:mm:ss"),
            endTime: endTime.toString(format: "HH:mm:ss"),
            maxTime: maxTime.toString(format: "HH:mm:ss"),
            type: .total
        )
        
        self.eclipse = temporaryEclipse
    }
    
    // 다음 월식날짜를 가져옵니다.
    func loadNextEclipse() {
        if let nextEclipse = EclipseDataManager.shared.getNextEclipse(from: Date()) {
            self.eclipse = nextEclipse
        }
    }
    
    func start(){
        Task{
            await cancelAllRunningActivities()
            startNewLiveActivity()
        }
    }
    
    // 현재 실행중인 모든 Activites를 중지합니다.
    private func cancelAllRunningActivities() async {
        for activity in Activity<EclipseAttributes>.activities {
            
            let finalContentState = EclipseAttributes.ContentState(
                progress: 1.0,
                currentTime: Date()
            )
            let staleDate = Date().addingTimeInterval(10)
            let activityContent = ActivityContent(state: finalContentState, staleDate: staleDate)
            
            await activity.end(activityContent, dismissalPolicy: .immediate)
        }
        
        await MainActor.run {
            activityID = nil
        }
    }
    
    private func startNewLiveActivity() {
        Task {
            
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
            let staleDate = endTime.addingTimeInterval(10) // endTime으로부터 5분 후
            // acitivity에 관련한 동적 데이터는 ActivityContent라는 wrapper 싸서 넣어줘야함
            let activityContent = ActivityContent(state: initialContentState, staleDate: staleDate)
            
            
            let activity = try? Activity.request(attributes: initialAttributes, content: activityContent, pushType: nil)
            
            await MainActor.run { activityID = activity?.id }
        }
        
    }
    
    func startTimer() {
        timer?.invalidate() // 이미 활성화되어있는 timer가 있는지 확인해서 끄고 새로운 타이머를 시작
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateLiveActivity()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateLiveActivity() {
        Task {
            guard let activityID = await activityID,
                  let runningActivity = Activity<EclipseAttributes>.activities.first(where: { $0.id == activityID }) else {
                return
            }
            guard 
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
            
            let staleDate = eclipse.endDateTime?.addingTimeInterval(10) ?? Date().addingTimeInterval(10)
            let activityContent = ActivityContent(state: updatedContentState, staleDate: staleDate)
            
            await runningActivity.update(activityContent)
            
            // 종료 시점을 감지하고 endActivity 호출
            if currentTime >= endTime {
                print("end activity")
                endActivity()
            }
        }
    }
    
    func endActivity() {
        Task {
            guard let activityID = await activityID,
                  let runningActivity = Activity<EclipseAttributes>.activities.first(where: { $0.id == activityID }) else {
                return
            }
            
            let finalContentState = EclipseAttributes.ContentState(
                progress: 1.0,
                currentTime: runningActivity.attributes.eclipseEndTime
            )
            let staleDate = Date().addingTimeInterval(10)
            let activityContent = ActivityContent(state: finalContentState, staleDate: staleDate)
            
            await runningActivity.end(activityContent, dismissalPolicy: .immediate)
            await MainActor.run { self.activityID = nil }
            stopTimer()
        }
        
    }
    
}
