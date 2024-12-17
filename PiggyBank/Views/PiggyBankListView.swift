import SwiftUI

struct PiggyBankListView: View {
    @FetchRequest(
        entity: PiggyBank.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PiggyBank.name, ascending: true)]
    ) var piggyBanks: FetchedResults<PiggyBank>

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            List {
                ForEach(piggyBanks) { piggyBank in
                    NavigationLink(destination: TransactionListView(piggyBank: piggyBank)) {
                        VStack(alignment: .leading) {
                            Text(piggyBank.name)
                                .font(.headline)
                            HStack {
                                Text("Saved: \(piggyBank.currentAmount, specifier: "%.2f")")
                                Spacer()
                                Text("Goal: \(piggyBank.goal, specifier: "%.2f")")
                            }
                            ProgressView(value: piggyBank.currentAmount, total: piggyBank.goal)
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        }
                    }
                }
                .onDelete(perform: deletePiggyBank)
            }
            .navigationTitle("Piggy Banks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddPiggyBankView()) {
                        Label("Add Piggy Bank", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func deletePiggyBank(at offsets: IndexSet) {
        offsets.map { piggyBanks[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete Piggy Bank: \(error)")
        }
    }
}


struct PiggyBankListView_Previews: PreviewProvider {
    static var previews: some View {
        let previewController = PersistenceController(inMemory: true)
        let context = previewController.container.viewContext
        
        let piggyBank = PiggyBank(context: context)
        piggyBank.name = "Vacation Fund"
        piggyBank.goal = 1000.0
        piggyBank.currentAmount = 0.00

        let secondPiggyBank = PiggyBank(context: context)
        secondPiggyBank.name = "Emergency Fund"
        secondPiggyBank.goal = 500.0
        secondPiggyBank.currentAmount = 0.00

        return PiggyBankListView()
            .environment(\.managedObjectContext, context)
    }
}
