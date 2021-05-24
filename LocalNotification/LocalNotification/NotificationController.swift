//
//  NotificationController.swift
//  LocalNotification
//
//  Created by Suguru Takahashi on 2021/05/24.
//

import Foundation
import NotificationCenter

class NotificationController: NSObject, ObservableObject {

    override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }

    static let dailyNotificationIdentifier = "DailyNotification"

    static var isDetermined: Bool {
        let center = UNUserNotificationCenter.current()
        var res: Bool = false
        let semaphore = DispatchSemaphore(value: 0)
        center.getNotificationSettings { (settings) in
            res = settings.authorizationStatus != .notDetermined
            semaphore.signal()
        }
        semaphore.wait()
        return res
    }

    static var isDenied: Bool {
        let center = UNUserNotificationCenter.current()
        var res: Bool = false
        let semaphore = DispatchSemaphore(value: 0)
        center.getNotificationSettings { (settings) in
            res = settings.authorizationStatus == .denied
            semaphore.signal()
        }
        semaphore.wait()
        return res
    }

    static func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            if let _ = error {
                return
            }
            if granted {
                setDefaultNotification()
            }
        }
    }

    static func setDefaultNotification() {
        setDailyNotification(date: Date(dateString: "10:00", with: "hh:mm") ?? Date())
    }

    static func setDailyNotification(date: Date) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        // TODO: 設定画面からメッセージを変更できるようにする（content.subtitleに設定することも視野に入れる）
        content.title = "1日1回アプリを開こう"
        content.sound = UNNotificationSound.default
        let date = DateComponents(hour: date.hour, minute: date.minute)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)
        let request = UNNotificationRequest.init(identifier: NotificationController.dailyNotificationIdentifier, content: content, trigger: trigger)
        center.add(request)
    }

    static func removePendingNotification(identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

extension NotificationController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .list, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
