//
//  home page.swift
//  hackthon
//
//  Created by maya alasiri  on 04/02/1447 AH.
//
import SwiftUI

// MARK: - View
struct HomePage: View {
    @EnvironmentObject var viewModel: BasicSetupViewModel
    @State private var cardOffsetX: CGFloat = 0
    @State private var cardOffsetY: CGFloat = 0
    @State private var goToSetup = false

    var body: some View {
        ZStack {
            // 🔹 Background
            Image("background main")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // 🔹 White rectangle fixed at bottom with transactions inside
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 17)
                        .fill(Color.white)
                        .frame(width: 343, height: 354)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(transactions.prefix(4)) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding()
                    }
                    .frame(width: 320, height: 310)

                    // 🔹 Show all button at bottom-left
                    Image("show all button")
                        .resizable()
                        .frame(width: 53, height: 15.81) // Adjust to your asset size
                        .offset(x: -130, y: 153)
                }
                .offset(y: -60)
            }

            // 🔹 Word image (absolute position, not affected)
            Image("word")
                .resizable()
                .frame(width: 103, height: 20)
                .offset(x: 109, y: 0)

            // 🔹 Main VStack content
            VStack {
                // Top Bar
                HStack {
                    HStack(spacing: 10) {
                        Button {
                            goToSetup = true
                        } label: {
                            Image("Sign_out_squre")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }

                        Image("Bell")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.leading)

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(viewModel.cardOwner)
                            .font(.custom("Inter_18pt-Medium", size: 15))
                            .foregroundColor(Color(red: 0/255, green: 21/255, blue: 44/255))

                        Text(viewModel.caregiverName)
                            .font(.custom("Inter_18pt-ThinItalic", size: 8))
                            .foregroundColor(Color(red: 0/255, green: 21/255, blue: 44/255))
                    }

                    Image("Usercicrle")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .padding(.trailing)
                }
                .padding(.top, 20)

                // Navigation
                NavigationLink("", destination: BasicSetupView(), isActive: $goToSetup)
                    .hidden()

                Spacer()

                // Card
                ZStack {
                    Image("card")
                        .resizable()
                        .frame(width: 320, height: 200)
                        .offset(x: cardOffsetX, y: cardOffsetY)

                    if let money = Double(viewModel.money) {
                        Text("\(Int(money))")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .offset(x: 10, y: -2)
                    }
                }
                .padding(.bottom, 480)

                // Buttons
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Image("daily limit button")
                            .resizable()
                            .frame(width: 95, height: 86)
                            .offset(x: -10, y: -480)
                    }

                    Button(action: {}) {
                        Image("frezz button")
                            .resizable()
                            .frame(width: 63, height: 80)
                            .offset(x: -19, y: -480)
                    }

                    Button(action: {}) {
                        Image("add caregiver")
                            .resizable()
                            .frame(width: 63, height: 80)
                            .offset(x: -17, y: -480)
                    }
                }
                .padding(.bottom, -20)

                Spacer()
            }
        }
    }
}

// MARK: - ViewModel
class HomePageViewModel: ObservableObject {
    // Not used yet
}

// MARK: - Transaction Model
struct Transaction: Identifiable {
    let id = UUID()
    let amount: Double
    let description: String
    let date: String
}

// MARK: - Sample Data
let transactions: [Transaction] = [
    Transaction(amount: 368.66, description: "إعانة مالية", date: "2025-08-01"),
    Transaction(amount: -400.00, description: "أبل باي ", date: "2025-08-01"),
    Transaction(amount: -10.4, description: "أبل باي ", date: "2025-08-01"),
    Transaction(amount: -73.0, description:"أبل باي ", date: "2025-08-01"),
    Transaction(amount: 129.0, description: "أبل باي ", date: "2025-08-02")
]

// MARK: - Transaction Row View
struct TransactionRow: View {
    var transaction: Transaction

    // Custom purple color (hex: #130138)
    let customPurple = Color(red: 19/255, green: 1/255, blue: 56/255)

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                    .foregroundColor(customPurple)

                Text(transaction.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(String(format: "%.2f ر.س", abs(transaction.amount)))
                .font(.headline)
                .foregroundColor(transaction.amount < 0 ? customPurple : .green)

            ZStack {
                Circle()
                    .fill(transaction.amount < 0 ? Color.gray.opacity(0.2) : Color.green.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: transaction.amount < 0 ? "arrow.right" : "arrow.left")
                    .foregroundColor(transaction.amount < 0 ? customPurple : .green)
            }
            .padding(.leading, 10)
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        HomePage()
            .environmentObject(BasicSetupViewModel())
    }
}
