//
//  LoanView.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI
import CoreData

struct LoanView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Loans.entity(), sortDescriptors: []) var loans: FetchedResults<Loans>
    
    @State private var navigationSelectionTag: Int? = 0

    var body: some View {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return NavigationView {
            VStack {
                VStack{
                    List {
                        Section(header: Text("Loans").font(.headline)){
                            ForEach(self.loans, id: \.id) { loan in
                                VStack{
                                    NavigationLink(destination: LoanDetail(loanItem: loan)) {
                                        VStack(alignment: .leading){
                                            HStack{
                                                Text("\(loan.name ?? "") - ")
                                                Text("$\(loan.currentPrincipal ?? 0)")
                                            }
                                            Text("Next Payment Date: \(formatter.string(from: loan.nextDueDate ?? Date()))").font(.caption)
                                        }
                                    }
                                }
                            }.onDelete(perform: deleteLoans)
                            
                        }
                        
                        Section(header: Text("Total").font(.headline)){
                            Text("Total Debt")
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .navigationBarTitle("Overview")
                }
                VStack {
                   NavigationLink(destination: LoanAdder(), tag: 1, selection: $navigationSelectionTag) {
                        EmptyView()
                   }.navigationBarItems(leading: EditButton(), trailing: Button(action: {self.navigationSelectionTag = 1}) {
                        HStack{
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .imageScale(.medium)
                            Text("Loan")
                    }})
                }
            }
        }
    }
    func deleteLoans(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let loan = loans[offset]

            // delete it from the context
            managedObjectContext.delete(loan)
        }

        // save the context
        try? managedObjectContext.save()
    }
}


struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        LoanView()
    }
}