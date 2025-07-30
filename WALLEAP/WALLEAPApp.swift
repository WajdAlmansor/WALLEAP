import SwiftUI
import UserNotifications

@main
struct WALLEAPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            SpendingRiskTesterView()
        }
    }
}

// MARK: - AppDelegate لتسجيل NotificationDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    let notificationDelegate = NotificationDelegate()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        let center = UNUserNotificationCenter.current()
        center.delegate = notificationDelegate

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("🔔 الإشعارات مفعلة")
            } else {
                print("❌ تم رفض الإشعارات")
            }
        }

        return true
    }
}
