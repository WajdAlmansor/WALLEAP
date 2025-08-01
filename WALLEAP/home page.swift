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
    @ObservedObject var transactionData = TransactionData()
    @State private var cardOffsetX: CGFloat = 0
    @State private var cardOffsetY: CGFloat = 0
    @State private var goToSetup = false
    @State private var goToSpendingLimit = false // ✅ حالة تنقل جديدة

    var body: some View {
        ZStack {
            Image("background main")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 17)
                        .fill(Color.white)
                        .frame(width: 343, height: 354)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(transactionData.transactions.prefix(4)) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding()
                    }
                    .frame(width: 320, height: 310)

                    Image("show all button")
                        .resizable()
                        .frame(width: 53, height: 15.81)
                        .offset(x: -130, y: 153)
                }
                .offset(y: -60)
            }

            Image("word")
                .resizable()
                .frame(width: 103, height: 20)
                .offset(x: 109, y: 0)

            VStack {
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

                // ✅ NavigationLinks
                NavigationLink(destination: BasicSetupView(), isActive: $goToSetup) {
                    EmptyView()
                }
                .hidden()

                NavigationLink(destination: SpendingLimitView(), isActive: $goToSpendingLimit) {
                    EmptyView()
                }
                .hidden()

                Spacer()

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

                // ✅ Buttons with action
                HStack(spacing: 16) {
                    Button(action: {
                        goToSpendingLimit = true // ← عند الضغط ننتقل للصفحة
                    }) {
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
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - ViewModel
class HomePageViewModel: ObservableObject {
    // Not used yet
}

// MARK: - Preview
#Preview {
    NavigationStack {
        HomePage()
            .environmentObject(BasicSetupViewModel())
    }
}
