//
//  Bank_Transaction.swift
//  WALLEAP
//
//  Created by Lina Alharbi on 05/02/1447 AH.
//
import SwiftUI

struct Bank_Transaction: View {
    @ObservedObject var transactionData = TransactionData() // Use shared data
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
                    // Back Button
                    HStack {
                        NavigationLink(destination: HomePage()) {
                            Image("BackArrow") // Use your asset name for the back arrow
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60) // Set the size of the back arrow
                                .padding()
                                .padding(.leading, -20)
                        }
                        Spacer()
                    }
                    
                    // Title Overlay
                    Text("العمليات السابقة")
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.top, -70)
                    
                    // Space between title and search bar
                    Spacer(minLength: 20)
                    
                    // Search Bar
                    SearchBar(text: $searchText)
                    
                    // Space between search bar and list
                    Spacer(minLength: 20)
                    
                    // Scrollable List of Transactions
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(transactionData.transactions.prefix(12)) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: .infinity) // Ensure the ScrollView takes available space
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    // Custom Search Bar View
    struct SearchBar: View {
        @Binding var text: String
        
        var body: some View {
            HStack {
                // Equalizer asset on the left
                Image("equalizer") // Replace "equalizer" with your asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30) // Set the size of the equalizer
                    .padding(.trailing, 20) // Space between equalizer and search bar
                
                TextField("ابحث بالاسم أو المبلغ", text: $text)
                    .padding(7)
                    .padding(.trailing, 25) // Adjust padding for right alignment
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .multilineTextAlignment(.trailing) // Align text to the right
                    .keyboardType(.default) // Set the keyboard type
                    .frame(width: 300) // Set the width of the search bar
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black.opacity(0.2))
                                .padding(.trailing, 8) // Padding for the icon
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
