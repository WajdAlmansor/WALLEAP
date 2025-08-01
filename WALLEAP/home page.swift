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

    var body: some View {
        NavigationStack {
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
                            VStack(spacing: 1) {
                                ForEach(transactionData.transactions.prefix(4)) { transaction in
                                    TransactionRow(transaction: transaction)
                                }
                            }
                            .padding()
                        }
                        .frame(width: 320, height: 310)

                        // 🔹 Show all button at bottom-left → Navigates to Bank_Transaction
                        NavigationLink(destination: Bank_Transaction()) {
                            Image("show all button")
                                .resizable()
                                .frame(width: 53, height: 15.81)
                        }
                        .offset(x: -128, y: 153)
                    }
                    .offset(y: -60)
                }

                // 🔹 Word image (absolute position)
                Image("word")
                    .resizable()
                    .frame(width: 113, height: 18)
                    .offset(x: 101, y: 0)

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
                                   .font(.system(size: 15))
                                   .fontWeight(.bold)
                                   .foregroundColor(Color(red: 0/255, green: 21/255, blue: 44/255))

                            Text(viewModel.caregiverName)
                                  .font(.system(size: 8))
                                  .fontWeight(.bold)
                                  .foregroundColor(Color(red: 0/255, green: 21/255, blue: 44/255))
                        }
                       // Spacer()

                        Image("Usercicrle")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .padding(.trailing)
                    }
                    .padding(.top, 20)

                    // Navigation to Setup Page
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
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - ViewModel
class HomePageViewModel: ObservableObject {
    // Not used yet
}

// MARK: - Preview
#Preview {
    HomePage()
        .environmentObject(BasicSetupViewModel())
}
