import SwiftUI

// MARK: - View
struct BasicSetupView: View {
    @StateObject private var viewModel = BasicSetupViewModel()
    @State private var goToHome = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("مرحبا")
                    .font(.title)
                    .bold()

                TextField("اسم صاحب البطاقة", text: $viewModel.cardOwner)
                    .textFieldStyle(.roundedBorder)

                TextField("اسم ولي الامر", text: $viewModel.caregiverName)
                    .textFieldStyle(.roundedBorder)

                TextField("الرصيد الحالي", text: $viewModel.money)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                Button("حفظ") {
                    goToHome = true
                }
                .buttonStyle(.borderedProminent)

                NavigationLink("", destination: HomePage()
                                .environmentObject(viewModel)
                                .navigationBarBackButtonHidden(true),
                               isActive: $goToHome)
                .hidden()
            }
            .padding()
        }
    }
}

// MARK: - ViewModel
class BasicSetupViewModel: ObservableObject {
    @Published var cardOwner: String = ""
    @Published var caregiverName: String = ""
    @Published var money: String = ""
}

// MARK: - Preview
#Preview {
    BasicSetupView()
}
