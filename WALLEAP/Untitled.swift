import SwiftUI
import Charts
import CoreML

// MARK: - نموذج الصرف اليومي
struct DailySpending: Identifiable {
    let id = UUID()
    let date: String  // "Jul 28"
    let amount: Double
}

// MARK: - تحميل البيانات من CSV
func loadAllSpendingData() -> [DailySpending] {
    guard let path = Bundle.main.path(forResource: "Final_500_Rows_Dataset", ofType: "csv") else { return [] }

    var raw: [(String, Double)] = []

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "MMM d"

    do {
        let content = try String(contentsOfFile: path)
        let rows = content.components(separatedBy: .newlines).dropFirst()
        for row in rows {
            let cols = row.components(separatedBy: ",")
            if cols.count >= 2,
               let amount = Double(cols[1]),
               let rawDate = cols.first,
               let date = dateFormatter.date(from: rawDate) {
                let dayString = displayFormatter.string(from: date)
                raw.append((dayString, amount))
            }
        }
    } catch {
        print("❌ فشل في قراءة CSV: \(error)")
    }

    let grouped = Dictionary(grouping: raw, by: { $0.0 })
        .map { key, values in
            DailySpending(date: key, amount: values.map { $0.1 }.reduce(0, +))
        }
        .sorted { $0.date < $1.date }

    return grouped
}

// MARK: - واجهة الرسم البياني
struct SpendingChartView: View {
    let allData = loadAllSpendingData()
    @AppStorage("dailyLimit") private var savedDailyLimit: Double = 0.0

    @State private var weekIndex: Int = 0
    @State private var recommendation: String = ""

    var currentWeek: [DailySpending] {
        let start = weekIndex * 7
        let end = min(start + 7, allData.count)
        if start < end {
            return Array(allData[start..<end])
        }
        return []
    }

    func updateRecommendation() {
        let totalSpent = currentWeek.map { $0.amount }.reduce(0, +)
        let weeklyLimit = savedDailyLimit * 7
        let remaining = weeklyLimit - totalSpent
        let usageRatio = weeklyLimit > 0 ? totalSpent / weeklyLimit : 0

        print("✅ الحالة:")
        print("- الحد الأسبوعي =", weeklyLimit)
        print("- مجموع الصرف =", totalSpent)
        print("- المتبقي =", remaining)
        print("- نسبة الاستخدام =", usageRatio)

        do {
            let inputArray = try MLMultiArray(shape: [1, 4], dataType: .float32)
            inputArray[0] = NSNumber(value: Float(totalSpent))
            inputArray[1] = NSNumber(value: Float(weeklyLimit))
            inputArray[2] = NSNumber(value: Float(remaining))
            inputArray[3] = NSNumber(value: Float(usageRatio))

            let model = try ModelModel(configuration: .init())
            let prediction = try model.prediction(input: inputArray)

            switch prediction.classLabel {
            case 0:
                recommendation = "✅ استمر، الحد مناسب"
            case 1:
                recommendation = "🟡 قلل الحد الأسبوعي"
            case 2:
                recommendation = "❗️تجاوزت الحد، راجع مصروفك"
            default:
                recommendation = "❓ توصية غير معروفة"
            }
        } catch {
            recommendation = "❌ خطأ: \(error.localizedDescription)"
        }
    }

    var body: some View {
        VStack {
            Text("تحليل صرف الأسبوع")
                .font(.title2)
                .bold()
                .padding(.top)

            Chart(currentWeek) { item in
                BarMark(
                    x: .value("اليوم", item.date),
                    y: .value("المبلغ", item.amount)
                )
                .foregroundStyle(.teal)
            }
            .frame(height: 250)
            .padding()

            HStack {
                Button("⬅️ الأسبوع السابق") {
                    if weekIndex > 0 {
                        weekIndex -= 1
                        updateRecommendation()
                    }
                }
                Spacer()
                Button("الأسبوع التالي ➡️") {
                    if (weekIndex + 1) * 7 < allData.count {
                        weekIndex += 1
                        updateRecommendation()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)

            Text("التوصية:")
                .font(.headline)
                .padding(.top, 10)

            Text(recommendation)
                .padding(.bottom)

            Spacer()
        }
        .navigationTitle("الرسم البياني")
        .onAppear {
            updateRecommendation()
        }
    }
}

#Preview {
    SpendingChartView()
}
