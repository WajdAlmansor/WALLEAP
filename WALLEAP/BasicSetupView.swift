//
//  BasicSetupView.swift
//  WALLEAP
//
//  Created by maya alasiri  on 06/02/1447 AH.
//import SwiftUI
import SwiftUI
// MARK: - View
struct BasicSetupView: View {
    @StateObject private var viewModel = BasicSetupViewModel()
    @State private var goToHome = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Welcome")
                    .font(.title)
                    .bold()

                TextField("Card Owner Name", text: $viewModel.cardOwner)
                    .textFieldStyle(.roundedBorder)

                TextField("Caregiver Name", text: $viewModel.caregiverName)
                    .textFieldStyle(.roundedBorder)

                TextField("Current Money", text: $viewModel.money)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                Button("Done") {
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


