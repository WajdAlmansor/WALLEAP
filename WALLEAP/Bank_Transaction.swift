import SwiftUI
import CoreML
import UserNotifications

struct Bank_Transaction: View {
    @ObservedObject var transactionData = TransactionData()
    @State private var searchText = ""
    @AppStorage("dailyLimit") private var savedDailyLimit: Double = 0.0

    // تحميل الموديل
    let model: NewModel = {
        do {
            return try NewModel(configuration: .init())
        } catch {
            fatalError("❌ فشل تحميل الموديل: \(error)")
        }
    }()

    var body: some View {
        NavigationView {
            ZStack {
                Image("riyadh")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        NavigationLink(destination: HomePage()) {
                            Image("BackArrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding()
                                .padding(.leading, -20)
                        }
                        Spacer()
                    }

                    Text("العمليات السابقة")
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.top, -70)

                    Spacer(minLength: 20)
                    SearchBar(text: $searchText)
                    Spacer(minLength: 20)

                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(transactionData.transactions.prefix(12)) { transaction in
                                if transaction.amount < 0 {
                                    Button(action: {
                                        predict(amount: abs(transaction.amount))
                                    }) {
                                        TransactionRow(transaction: transaction)
                                    }
                                    .buttonStyle(PlainButtonStyle()) // بدون تأثير زر
                                } else {
                                    TransactionRow(transaction: transaction) // للعمليات غير السحب فقط
                                }
                            }

                        }
                        .padding()
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    func predict(amount: Double) {
        let limit = savedDailyLimit > 0 ? savedDailyLimit : 50

        let inputValues: [Double] = [
            amount,
            0,
            0,
            0,
            0,
            limit,
            limit - amount,
            amount / max(limit, 1),
            limit - 0
        ]

        print("🧪 amount = \(amount), limit = \(limit)")

        do {
            let mlArray = try MLMultiArray(shape: [1, NSNumber(value: inputValues.count)], dataType: .double)
            for (index, value) in inputValues.enumerated() {
                mlArray[[0, NSNumber(value: index)]] = NSNumber(value: value)
            }

            let input = NewModelInput(input: mlArray)
            let prediction = try model.prediction(input: input)
            let label = Int(prediction.classLabel)

            print("🎯 Result: label = \(label)")

            if label == 1 {
                showNotification(title: "⚠️ تنبيه صرف", body: "المبلغ المسحوب قريب من الحد اليومي")
            }
        } catch {
            print("❌ Error: \(error)")
        }
    }


    func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )


        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    struct SearchBar: View {
        @Binding var text: String

        var body: some View {
            HStack {
                Image("equalizer")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 20)

                TextField("ابحث بالاسم أو المبلغ", text: $text)
                    .padding(7)
                    .padding(.trailing, 25)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.default)
                    .frame(width: 300)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black.opacity(0.2))
                                .padding(.trailing, 8)
                        }
                    )
            }
            .padding(.horizontal)
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("📣 NotificationDelegate activated - foreground notification incoming")
        completionHandler([.banner, .sound])
    }
}

#Preview {
    Bank_Transaction()
    
        .environmentObject(BasicSetupViewModel())
}
