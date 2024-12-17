import SwiftUI

struct AddTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var piggyBank: PiggyBank

    @State private var amount: String = ""
    @State private var note: String = ""
    @State private var date = Date()

    var body: some View {
        
        VStack {
            PiggyBankAnimationView()
                .frame(width: 300, height: 300)
            
            Form {
                
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                TextField("Note (Optional)", text: $note)
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                
                Button("Save Transaction") {
                    if let amountValue = Double(amount) {
                        addTransaction(to: piggyBank, amount: amountValue, note: note, date: date)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(amount.isEmpty)
            }
            .navigationTitle("Add Transaction")
        }
    }

    private func addTransaction(to piggyBank: PiggyBank, amount: Double, note: String?, date: Date) {
        let transaction = Transaction(context: viewContext)
        transaction.amount = amount
        transaction.date = date
        transaction.note = note
        transaction.piggyBank = piggyBank

        piggyBank.currentAmount += amount

        do {
            try viewContext.save()
            print("Transaction saved!")
        } catch {
            print("Failed to save transaction: \(error)")
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        let previewController = PersistenceController(inMemory: true)
        let context = previewController.container.viewContext

        let piggyBank = PiggyBank(context: context)
        piggyBank.name = "Vacation Fund"
        piggyBank.goal = 1000.0
        piggyBank.currentAmount = 250.0

        let transaction = Transaction(context: context)
        transaction.amount = 50.0
        transaction.note = "Groceries"
        transaction.date = Date()
        transaction.piggyBank = piggyBank

        return AddTransactionView(piggyBank: piggyBank)
            .environment(\.managedObjectContext, context)
    }
}
