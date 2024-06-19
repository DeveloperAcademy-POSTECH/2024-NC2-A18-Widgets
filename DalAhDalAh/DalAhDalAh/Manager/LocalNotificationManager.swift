//
//  LocalNotificationManager.swift
//  DalAhDalAh
//
//  Created by 이종선 on 6/19/24.
//

//import Foundation
//import NotificationCenter
//
//// The Protocol defined by Objective-C
//// To conform that protocl in Swift class, have to conform NSObject protocol together
//@MainActor
//class LocalNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
//    
//    
//    let notificationCenter = UNUserNotificationCenter.current()
//    @Published private var isGranted = false
//    @Published var pendingRequests: [UNUserNotificationCenter] = [] // notifiaction list that are yet triggered
//    
//    override init(){
//        super.init()
//        notificationCenter.delegate = self
//    }
//    
//    // Delegate Functions implements
//    // When App is foreground, basically don't get the notifications
//    // so cofigure notification operation when app is foreground, we have to
//    // conform UNUserNotificationDelegate and implement below function
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//        await getPendingRequests()
//        return [.sound, .banner]
//    }
//    
//    // Register localNotification object on NotificationCenter
//    func schedule(localNotification: LocalNotification) async {
//        
//        // configure notification cotents
//        let content = UNMutableNotificationContent()
//        content.title = localNotification.title
//        content.body = localNotification.body
//        content.sound = .default
//        
//        // trigger 종류 설정
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: localNotification.timeInterval,
//                                                        repeats: localNotification.repeats)
//        // notification 식별자, trigger, content를 설정하여 request 구성
//        let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
//        
//        // notifcationCenter에 구성한 request 등록
//        try? await notificationCenter.add(request)
//        
//        await getPendingRequests()
//    }
//    
//    // request가 생성되었지만 아직 trigger가 되지 않은 notification들은
//    // 특정 조건이 만족될때까지 pending 상태에 존재
//    func getPendingRequests() async {
//        pendingRequests = await notificationCenter.pendingNotificationRequests()
//        print("Pending: \(pendingRequests.count)")
//    }
//    
//    func removeRequest(withIdentifier identifier: String) {
//        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
//        if let index = pendingRequests.firstIndex(where: {$0.identifier == identifier}) {
//            pendingRequests.remove(at: index)
//            print("Pending: \(pendingRequests.count)")
//        }
//    }
//    
//    func clearRequests() {
//        notificationCenter.removeAllPendingNotificationRequests()
//        pendingRequests.removeAll()
//        print("Pending: \(pendingRequests.count)")
//    }
//    
//    
//    //MARK: Methods for get the authorization from user
//    func requestAuthorization() async throws {
//        try await notificationCenter
//            .requestAuthorization(options: [.sound, .badge, .alert])
//        await getCurrentSettings()
//    }
//    
//    func getCurrentSettings() async {
//        let currentSettings = await notificationCenter.notificationSettings()
//        isGranted = (currentSettings.authorizationStatus == .authorized)
//        
//    }
//    
//    func openSettings(){
//        if let url = URL(string: UIApplication.openSettingsURLString){
//            if UIApplication.shared.canOpenURL(url){
//                Task{
//                    await UIApplication.shared.open(url)
//                }
//            }
//        }
//    }
//    
//    
//}
