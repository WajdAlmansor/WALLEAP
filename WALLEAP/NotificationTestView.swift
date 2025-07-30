//import SwiftUI
//import UserNotifications
//
//struct NotificationTestView: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("🔔 اختبار الإشعار")
//                .font(.title)
//
//            Button("إرسال إشعار الآن") {
//                sendTestNotification()
//            }
//            .buttonStyle(.borderedProminent)
//        }
//        .padding()
//        .onAppear {
//            requestNotificationPermission()
//        }
//    }
//
//    func requestNotificationPermission() {
//        let center = UNUserNotificationCenter.current()
//        center.delegate = NotificationDelegate.shared
//        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
//            if granted {
//                print("✅ تم تفعيل الإشعارات")
//            } else {
//                print("❌ لم يتم تفعيل الإشعارات")
//            }
//        }
//    }
//
//    func sendTestNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "🚨 إشعار تجريبي"
//        content.body = "هذا إشعار محلي تم إرساله من داخل التطبيق."
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString,
//                                            content: content,
//                                            trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("❌ فشل إرسال الإشعار: \(error)")
//            } else {
//                print("✅ تم إرسال الإشعار")
//            }
//        }
//    }
//}
//
//// MARK: - يسمح بعرض الإشعار حتى لو التطبيق مفتوح
//class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
//    static let shared = NotificationDelegate()
//
//    private override init() {
//        super.init()
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .sound])
//    }
//}
//
//#Preview {
//    NotificationTestView()
//}
