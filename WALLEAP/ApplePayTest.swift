import SwiftUI
import PassKit

struct ApplePayTestView: View {
    var body: some View {
        PaymentButton(action: startApplePay)
            .frame(width: 200, height: 50)
    }

    func startApplePay() {
        let paymentItem = PKPaymentSummaryItem(label: "Test Purchase", amount: NSDecimalNumber(string: "9.99"))

        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.wajd.walleapp" // نفس اللي كتبتيه في Capabilities
        request.supportedNetworks = [.visa, .masterCard]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [paymentItem]

        guard let controller = PKPaymentAuthorizationViewController(paymentRequest: request) else {
            print("❌ فشل إنشاء شاشة الدفع")
            return
        }

        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            controller.delegate = ApplePayDelegate()
            rootVC.present(controller, animated: true, completion: nil)
        }
    }
}

struct PaymentButton: UIViewRepresentable {
    var action: () -> Void

    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        button.addTarget(context.coordinator, action: #selector(Coordinator.didTap), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: PKPaymentButton, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    class Coordinator: NSObject {
        let action: () -> Void
        init(action: @escaping () -> Void) { self.action = action }
        @objc func didTap() { action() }
    }
}

class ApplePayDelegate: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("✅ تمت الموافقة على الدفع")

        // ✅ هذا هو الخصم الوهمي فعليًا
        let currentBalance = UserDefaults.standard.double(forKey: "virtualBalance")
        let amount = 9.99
        let newBalance = currentBalance - amount
        UserDefaults.standard.set(newBalance, forKey: "virtualBalance")
        print("💸 رصيدك الجديد: \(newBalance)")

        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

