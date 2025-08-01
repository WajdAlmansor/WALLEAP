//
//  Bank_Transaction.swift
//  hackthon
//
//  Created by maya alasiri  on 07/02/1447 AH.
//

import SwiftUI

struct Bank_Transaction: View {
    @ObservedObject var transactionData = TransactionData()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("riyadh")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    // Custom Back Button (Optional – or remove entirely if not needed)
                    HStack {
                        NavigationLink(destination: HomePage()) {
                            Image("BackArrow 1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding()
                                .padding(.leading, -20)
                        }
                        Spacer()
                    }

                    // Title
                    Text("العمليات السابقة")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.top, -70)

                    Spacer(minLength: 20)

                    // Search Bar
                    SearchBar(text: $searchText)

                    Spacer(minLength: 20)

                    // 🔹 White rectangle with scrollable transactions
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 17)
                            .fill(Color.white)
                            .frame(width: 389, height: 714)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(transactionData.transactions.prefix(12)) { transaction in
                                    TransactionRow(transaction: transaction)
                                }
                            }
                            .padding(.top, 20)
                            .padding(.horizontal)
                        }
                        .frame(width: 370, height: 680)
                    }
                }
            }
//            .navigationBarBackButtonHidden(true) // ✅ This hides the blue back button
//                .navigationBarTitle("", displayMode: .inline)
           
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Search Bar
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

#Preview {
    Bank_Transaction()
        .environmentObject(BasicSetupViewModel())
}
