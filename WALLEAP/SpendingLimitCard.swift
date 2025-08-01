//
//  SpendingLimitCard.swift
//  WALLEAP
//
//  Created by khuloud nasser on 07/02/1447 AH.
//
import SwiftUI

struct SpendingLimitCard: View {
    var title: String
    var description: String
    var note: String

    var body: some View {
        ZStack {
            Image("cardBackground")
                .resizable()
                .scaledToFill()
                .frame(height: 160)
                .clipped()
                .cornerRadius(24)

            VStack(alignment: .trailing, spacing: 8) {
                HStack(alignment: .top) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16))
                        .foregroundColor(Color("PrimaryText"))
                        .padding(.top, 2)

                    Spacer()

                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("PrimaryText"))
                }

                VStack(alignment: .trailing, spacing: 4) {
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.trailing)

                    Text(note)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.top, 4)
            }
            .padding()
        }
        .frame(height: 160)
        .padding(.horizontal, 16)
    }
}

struct SpendingLimitView: View {
    @State private var goToHome = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Image("Group 33543")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // 🔙 زر الرجوع
                    NavigationLink(destination: HomePage().environmentObject(BasicSetupViewModel()), isActive: $goToHome) {
                        EmptyView()
                    }

                    HStack {
                        Button(action: {
                            goToHome = true
                        }) {
                            Image("BackArrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding()
                                .padding(.leading, -20)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 60)

                    Text("اختر حد الإنفاق")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("PrimaryText"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                        .padding(.top, 10)

                    VStack(spacing: 16) {
                        // ✅ ربط بطاقة "يومي" بصفحة SpendingLimit
                        NavigationLink(destination: SpendingLimit()) {
                            SpendingLimitCard(
                                title: "يومي",
                                description: "حدد حدًا للإنفاق اليومي للمساعدة في إدارة المصروفات بطريقة منظمة ومحكمة.",
                                note: "عند تعيين الحد، يتم إعادة ضبطه تلقائيًا كل يوم لضمان أن تظل المشتريات اليومية ضمن المبلغ المحدد."
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        SpendingLimitCard(
                            title: "أسبوعي",
                            description: "حدد حدًا للإنفاق الأسبوعي لتغطية المصروفات على مدار سبعة أيام.",
                            note: "عند تعيين الحد، يتم إعادة ضبطه تلقائيًا مع بداية كل أسبوع جديد."
                        )

                        SpendingLimitCard(
                            title: "شهري",
                            description: "حدد ميزانية شهرية لإدارة المصروفات طويلة الأجل بشكل أكثر فاعلية.",
                            note: "يتم تجديد هذا الحد تلقائيًا مع بداية كل شهر، مما يدعم التخطيط المالي المنتظم والسيطرة على الإنفاق."
                        )
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SpendingLimitView()
}
