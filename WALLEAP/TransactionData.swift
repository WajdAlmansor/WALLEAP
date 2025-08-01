//
//  TransactionData.swift
//  hackthon
//
//  Created by maya alasiri  on 07/02/1447 AH.
//

//
//  TransactionData.swift
//  WALLEAP
//
//  Created by Lina Alharbi on 06/02/1447 AH.
// Shared models and views for transactions

// TransactionData.swift
import SwiftUI
import Combine

// MARK: - Transaction Model
struct Transaction: Identifiable {
    let id = UUID()
    let amount: Double
    let description: String
    let date: String
  
}

// Shared Data Model
class TransactionData: ObservableObject {
    @Published var transactions: [Transaction] = [
        Transaction(amount: 368.66, description: "إعانة مالية", date: "2025-08-01"),
        Transaction(amount: -400.00, description: "أبل باي", date: "2025-08-01"),
        Transaction(amount: -10.4, description: "أبل باي", date: "2025-08-01"),
        Transaction(amount: -73.0, description: "أبل باي", date: "2025-08-01"),
        Transaction(amount: 129.0, description: "إعانة مالية", date: "2025-08-02"),
        Transaction(amount: -250.0, description: "أبل باي", date: "2025-08-03"),
        Transaction(amount: 150.0, description: "إعانة مالية", date: "2025-08-04"),
        Transaction(amount: -60.0, description: "أبل باي", date: "2025-08-05"),
        Transaction(amount: 200.0, description: "إعانة مالية", date: "2025-08-06"),
        Transaction(amount: -45.0, description: "أبل باي", date: "2025-08-07"),
        Transaction(amount: 500.0, description: "إعانة مالية", date: "2025-08-08"),
        Transaction(amount: -300.0, description: "أبل باي", date: "2025-08-09"),
        Transaction(amount: 100.0, description: "إعانة مالية", date: "2025-08-10"),
        Transaction(amount: -75.0, description: "أبل باي", date: "2025-08-11"),
        Transaction(amount: -150.0, description: "أبل باي", date: "2025-08-12"),
    ]
}
let customPurple = Color(red: 19/255, green: 1/255, blue: 56/255)
let customGreen = Color(red: 48/255, green: 164/255, blue: 79/255) // #30A44F

// MARK: - Transaction Row View
struct TransactionRow: View {
    var transaction: Transaction

    var body: some View {
        HStack {
//            VStack(alignment: .leading) {
//                Text(transaction.description)
//                    .font(.headline)
//                Text(transaction.date)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
            VStack(alignment: .leading) {
                           Text(transaction.description)
                               .font(.headline)
                               .foregroundColor(customPurple)

                           Text(transaction.date)
                               .font(.subheadline)
                               .foregroundColor(.gray)
                       }
            Spacer()
            HStack(spacing: -12) {
                Image(transaction.amount < 0 ? "riyadhSymbol" : "riyadhSymbol green")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.leading, -10)
                
                Text(String(format: "%.2f", abs(transaction.amount)))
                    .font(.headline)
                    .foregroundColor(transaction.amount < 0 ? customPurple : .green)
                //                Image(transaction.amount < 0 ? "riyadhSymbol" : "riyadhSymbol green")
                //                    .resizable()
                //                    .scaledToFit()
                //                    .frame(width: 50, height: 50)
                //                    .padding(.leading, -10)
            }
            Spacer()
                ZStack {
                    Circle()
                        .fill(transaction.amount < 0 ? Color.gray.opacity(0.2) : Color.green.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: transaction.amount < 0 ? "arrow.right" : "arrow.left")
                        .foregroundColor(transaction.amount < 0 ? customPurple : customGreen)
                }
               

            
         .padding(.leading, -10)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
