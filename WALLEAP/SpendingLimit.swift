import SwiftUI

struct SpendingLimit: View {
    @State private var selectedOption: Int? = 0
    @State private var customAmount: String = ""
    @AppStorage("dailyLimit") private var savedDailyLimit: Double = 0.0
    @State private var navigateToChart = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#DABFB4"),
                        Color(hex: "#FFF2EB")
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .ignoresSafeArea()

                Image("BackArrow")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(.leading, 20)
                    .padding(.top, 50)

                VStack(alignment: .trailing, spacing: 24) {
                    Spacer().frame(height: 100)

                    Text("الحد اليومي")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .offset(y: -60)

                    Text("اختر ميزانية مقترحة")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding(.trailing)

                    VStack(spacing: 12) {
                        BudgetOptionView(index: 0, selected: $selectedOption, label: "30 ﷼ – للاحتياجات اليومية الأساسية", isSelected: selectedOption == 0)
                        BudgetOptionView(index: 1, selected: $selectedOption, label: "50 ﷼ – متوسط الإنفاق اليومي", isSelected: selectedOption == 1)
                        BudgetOptionView(index: 2, selected: $selectedOption, label: "90 ﷼ – حد الطوارئ للمصاريف اليومية", isSelected: selectedOption == 2)
                    }
                    .padding(.horizontal)

                    Text("أو حدد مبلغك الخاص")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.trailing)

                    TextField("أدخل الحد اليومي", text: $customAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                        .padding(.horizontal)

                    Button(action: {
                        if let finalLimit = selectedLimitValue {
                            savedDailyLimit = finalLimit
                            print("✅ تم حفظ الحد اليومي: \(finalLimit)")
                            navigateToChart = true
                        } else {
                            print("⚠️ يرجى اختيار أو كتابة مبلغ صحيح")
                        }
                    }) {
                        Text("حفظ")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 244, height: 70)
                            .background(Color(hex: "#002D47"))
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.30), radius: 4, x: 0, y: 7)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.top, 12)

                    NavigationLink(
                        destination: Bank_Transaction(),
                        isActive: $navigateToChart
                    ) {
                        EmptyView()
                    }

                    Spacer()
                }
                .background(
                    Image("Rectangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 950.09, height: 825.93)
                        .offset(x: 120, y: 70),
                    alignment: .top
                )
                .padding(.top, 50)
            }
        }
    }

    var selectedLimitValue: Double? {
        // إذا فيه مبلغ مخصص مكتوب وصحيح، خله هو الأولوية
        if let custom = Double(customAmount), custom > 0 {
            return custom
        }

        // غير كذا، خذ من المقترح المحدد
        if let option = selectedOption {
            switch option {
            case 0: return 30
            case 1: return 50
            case 2: return 90
            default: return nil
            }
        }

        return nil
    }

}

struct BudgetOptionView: View {
    let index: Int
    @Binding var selected: Int?
    let label: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.black)
                .font(.system(size: 15))
                .padding(.trailing, 10)

            Spacer()

            Circle()
                .strokeBorder(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                .background(Circle().fill(isSelected ? Color.blue : Color.white))
                .frame(width: 20, height: 20)
        }
        .padding()
        .background(isSelected ? Color(red: 0.9, green: 0.92, blue: 1.0) : Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
        .onTapGesture {
            selected = index
        }
    }
}




extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    SpendingLimit()
}
