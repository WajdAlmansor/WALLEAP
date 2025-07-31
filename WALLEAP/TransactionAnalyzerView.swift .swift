import SwiftUI
import CoreML

// MARK: - نموذج العملية المالية
struct PurchaseRecord: Identifiable {
    let id = UUID()
    let amount: Double
    let dailyRunningTotal: Double
    let postTransactionBalance: Double
    let limit: Double
    let oldBalance: Double
    let newBalance: Double

    var usageRatio: Double {
        limit == 0 ? 0 : amount / limit
    }
}

// MARK: - محرك التنبؤ باستخدام CoreML
class PredictionEngine {
    private let model: LimitActionClassifier

    init() {
        do {
            model = try LimitActionClassifier(configuration: .init())
        } catch {
            fatalError("❌ فشل تحميل الموديل: \(error)")
        }
    }

 

    func predictAction(for record: PurchaseRecord) -> String {
        do {
            let inputArray: [Double] = [
                record.amount,
                record.dailyRunningTotal,
                record.postTransactionBalance,
                record.limit,
                record.oldBalance,
                record.newBalance,
                record.usageRatio
            ]

            // 2D array
            let mlArray = try MLMultiArray(shape: [1, 7], dataType: .double)
            for (index, value) in inputArray.enumerated() {
                mlArray[[0, NSNumber(value: index)]] = NSNumber(value: value)
            }

            let input = LimitActionClassifierInput(x: mlArray)
            let prediction = try model.prediction(input: input)

            switch prediction.classLabel {
            case "keep": return "🟢 ابقِ الحد كما هو"
            case "decrease": return "🔻 نقترح تقليل الحد"
            case "increase": return "🔺 نقترح رفع الحد"
            default: return "❓ توصية غير معروفة"
            }
        } catch {
            return "❌ خطأ في التنبؤ: \(error.localizedDescription)"
        }
    }
}

// MARK: - قراءة CSV وتحويله إلى عمليات
func loadPurchaseRecordsFromCSV() -> [PurchaseRecord] {
    guard let path = Bundle.main.path(forResource: "Final_500_Rows_Dataset", ofType: "csv") else {
        print("❌ ملف CSV غير موجود")
        return []
    }

    var records: [PurchaseRecord] = []

    do {
        let content = try String(contentsOfFile: path)
        let rows = content.components(separatedBy: .newlines).dropFirst()

        for row in rows {
            let cols = row.components(separatedBy: ",")
            if cols.count >= 7,
               let amount = Double(cols[1]),
               let dailyTotal = Double(cols[3]),
               let postBal = Double(cols[4]),
               let limit = Double(cols[5]),
               let oldBal = Double(cols[6]),
               let newBal = Double(cols[7]) {
                let record = PurchaseRecord(
                    amount: amount,
                    dailyRunningTotal: dailyTotal,
                    postTransactionBalance: postBal,
                    limit: limit,
                    oldBalance: oldBal,
                    newBalance: newBal
                )
                records.append(record)
            }
        }
    } catch {
        print("❌ خطأ في قراءة الملف: \(error)")
    }

    return records
}

// MARK: - الواجهة الرئيسية
struct TransactionAnalyzerView: View {
    let records = loadPurchaseRecordsFromCSV()
    let predictor = PredictionEngine()

    var body: some View {
        NavigationView {
            List(records) { record in
                VStack(alignment: .leading, spacing: 6) {
                    Text("💸 المبلغ: \(record.amount, specifier: "%.2f") ريال")
                    Text("📊 الاستخدام: \(record.usageRatio * 100, specifier: "%.1f")% من الحد (\(record.limit, specifier: "%.0f") ريال)")
                    Text(predictor.predictAction(for: record))
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("تحليل المشتريات")
        }
    }
}

// معاينة
#Preview {
    TransactionAnalyzerView()
}
