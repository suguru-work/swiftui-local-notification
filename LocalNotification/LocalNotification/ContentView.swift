//
//  ContentView.swift
//  LocalNotification
//
//  Created by Suguru Takahashi on 2021/05/24.
//

import SwiftUI

struct ContentView: View {
    // アプリ起動中でも通知を受け取るためにNotificationControllerをObservedObjectとして設置
    @ObservedObject var notificationController = NotificationController()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("")) {
                    NavigationLink(destination: PushSettingView()) {
                        Text("通知設定")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("設定", displayMode: .inline)
        }
        .onAppear {
            NotificationController.requestAuthorization()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
