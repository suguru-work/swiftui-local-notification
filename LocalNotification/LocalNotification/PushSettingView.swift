//
//  PushSettingView.swift
//  LocalNotification
//
//  Created by Suguru Takahashi on 2021/05/24.
//

import SwiftUI

struct PushSettingView: View {
    @AppStorage("LocalNotificationDate") var localNotificationDate = Date()
    @State var isDailyNotificationEnabled = true
    @State var showingAlert: Bool = false

    var body: some View {
        List {
            Section(header: Text("")) {
                Toggle("日次通知", isOn: $isDailyNotificationEnabled)
                    .onReceive([isDailyNotificationEnabled].publisher.first()) { _ in
                        if !isDailyNotificationEnabled {
                            NotificationController.removePendingNotification(identifier: NotificationController.dailyNotificationIdentifier)
                        }
                        if NotificationController.isDenied && isDailyNotificationEnabled {
                            // もし通知設定がONになっていない場合は設定アプリを立ち上げる
                            isDailyNotificationEnabled = false
                            showingAlert = true
                        }
                    }
                DatePicker("", selection: $localNotificationDate, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .disabled(!isDailyNotificationEnabled)
                    .onReceive([localNotificationDate].publisher.first()) { _ in
                        if isDailyNotificationEnabled {
                            NotificationController.setDailyNotification(date: localNotificationDate)
                        }
                    }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("通知設定", displayMode: .inline)
        .onAppear {
            if NotificationController.isDenied {
                isDailyNotificationEnabled = false
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("アプリからの通知を許可するためには端末の「設定」から通知を許可してください"),
                primaryButton: .default(Text("閉じる")),
                secondaryButton: .default(Text("設定する"), action: {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                })
            )
        }
    }
}

struct PushSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PushSettingView()
    }
}
