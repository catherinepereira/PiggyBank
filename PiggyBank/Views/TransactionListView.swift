import SwiftUI

struct TransactionListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var piggyBank: PiggyBank
    
    @State private var showDeleteConfirmation = false
    @State private var transactionToDelete: Transaction?

    var body: some View {
        let transactions = fetchTransactions(for: piggyBank)

        VStack {
            List {
                ForEach(transactions, id: \.self) { transaction in
                    VStack(alignment: .leading) {
                        Text("Amount: \(transaction.amount, specifier: "%.2f")")
                            .font(.headline)
                        if let note = transaction.note {
                            Text("Note: \(note)")
                                .font(.subheadline)
                        }
                        Text("Date: \(transaction.date, formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }.onDelete(perform: deleteTransaction)
            }
            .navigationTitle("\(piggyBank.name) Transactions").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTransactionView(piggyBank: piggyBank)) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Transaction"),
                    message: Text("Are you sure you want to delete this transaction?"),
                    primaryButton: .destructive(Text("Delete")) {
                        confirmDelete()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
   
    private func deleteTransaction(at offsets: IndexSet) {
        let transactions = fetchTransactions(for: piggyBank)
        offsets.forEach { index in
            transactionToDelete = transactions[index]
            showDeleteConfirmation = true
        }
    }

    private func confirmDelete() {
        if let transaction = transactionToDelete {
            viewContext.delete(transaction)
            do {
                try viewContext.save()
                print("Transaction deleted successfully!")
            } catch {
                print("Failed to delete transaction: \(error)")
            }
        }
        transactionToDelete = nil
    }

    private func fetchTransactions(for piggyBank: PiggyBank) -> [Transaction] {
        guard let transactions = piggyBank.transactions as? Set<Transaction> else {
            return []
        }
        return transactions.sorted { ($0.date) < ($1.date) }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

struct TransactionListView_Previews: PreviewProvider {
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

        return TransactionListView(piggyBank: piggyBank)
            .environment(\.managedObjectContext, context)
    }
}
