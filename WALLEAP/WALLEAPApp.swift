import SwiftUI
import UserNotifications

@main

struct WALLEAPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
           if UserDefaults.standard.object(forKey: "virtualBalance") == nil {
               UserDefaults.standard.set(100.0, forKey: "virtualBalance") // رصيد تجريبي
           }
       }
    
    var body: some Scene {
        WindowGroup {
            ApplePayTestView()
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
