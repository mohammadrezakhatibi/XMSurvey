//
//  XMSurveyApp.swift
//  XMSurvey
//
//  Created by Mohammadreza Khatibi on 15.04.24.
//

import SwiftUI
import App

@main
struct XMSurveyApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            AppScreen()
        }
    }
}

#if os(iOS)
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        guard ProcessInfo.processInfo.arguments.contains("–uitesting") else { return true }
        UITestingNetworkHandler.register()
        return true
    }
}
#endif
