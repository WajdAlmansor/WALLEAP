//import SwiftUI
//import CoreML
//import UserNotifications
//
//// MARK: - إشعار يظهر حتى لو التطبيق مفتوح
//class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .sound]) // ✅ Banner وصوت حتى في foreground
//    }
//}
//
//// MARK: - واجهة التنبؤ
//struct SpendingRiskTesterView: View {
//    @State private var amount: String = ""
//    @State private var limit: String = ""
//    @State private var predictionLabel: Int?
//
//    // تحميل الموديل
//    let model: NewModel = {
//        do {
//            return try NewModel(configuration: .init())
//        } catch {
//            fatalError("❌ فشل تحميل الموديل: \(error)")
//        }
//    }()
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                TextField("Amount", text: $amount)
//                    .keyboardType(.decimalPad)
//                    .textFieldStyle(.roundedBorder)
//
//                TextField("Limit", text: $limit)
//                    .keyboardType(.decimalPad)
//                    .textFieldStyle(.roundedBorder)
//
//                Button("🔍 توقع المخاطرة") {
//                    predict()
//                }
//                .buttonStyle(.borderedProminent)
//
//                if let label = predictionLabel {
//                    Text("🔎 التوقع: \(labelDescription(for: label))")
//                        .font(.title2)
//                        .padding()
//                }
//
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("اختبار المخاطر")
//        }
//    }
//
//    func predict() {
//        guard let amountValue = Double(amount),
//              let limitValue = Double(limit) else {
//            predictionLabel = nil
//            return
//        }
//
//        let inputValues: [Double] = [
//            amountValue,
//            0,
//            0,
//            0,
//            0,
//            limitValue,
//            limitValue - amountValue,
//            amountValue / max(limitValue, 1),
//            limitValue - 0
//        ]
//
//        do {
//            let mlArray = try MLMultiArray(shape: [1, NSNumber(value: inputValues.count)], dataType: .double)
//
//            for (index, value) in inputValues.enumerated() {
//                mlArray[[0, NSNumber(value: index)]] = NSNumber(value: value)
//            }
//
//            let input = NewModelInput(input: mlArray)
//            let prediction = try model.prediction(input: input)
//
//            let label = Int(prediction.classLabel)
//            predictionLabel = label
//
//            if label == 1 {
//                showNotification(title: "⚠️ تحذير إنفاق", body: "المبلغ قريب جدًا من الحد!")
//            }
//
//        } catch {
//            print("❌ خطأ في التوقع: \(error)")
//            predictionLabel = nil
//        }
//    }
//
//    func showNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//
//        let request = UNNotificationRequest(
//            identifier: UUID().uuidString,
//            content: content,
//            trigger: nil // ✅ فوري
//        )
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//    }
//
//    func labelDescription(for label: Int) -> String {
//        switch label {
//        case 0: return "آمن ✅"
//        case 1: return "تحذير ⚠️"
//        default: return "غير معروف"
//        }
//    }
//}
