import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            PiggyBankListView()
        }
        .onAppear {
            //runTestFunctions()
            //resetCoreDataStore()
        }
    }

    private func runTestFunctions() {
        addPiggyBank(name: "Test Bank 1", goal: 1000.0, context: viewContext)
        addPiggyBank(name: "Test Bank 2", goal: 500.0, context: viewContext)
        
        let piggyBanks = fetchPiggyBanks(context: viewContext)
        piggyBanks.forEach { bank in
            print("\(bank.name): \(bank.currentAmount)/\(bank.goal)")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let previewController = PersistenceController(inMemory: true)
        let context = previewController.container.viewContext

        let piggyBank = PiggyBank(context: context)
        piggyBank.name = "Test Bank 1"
        piggyBank.goal = 1000.0
        piggyBank.currentAmount = 0.00

        let anotherBank = PiggyBank(context: context)
        anotherBank.name = "Test Bank 2"
        anotherBank.goal = 500.0
        anotherBank.currentAmount = 0.00

        do {
            try context.save()
        } catch {
            print("Error saving preview data: \(error)")
        }

        return ContentView()
            .environment(\.managedObjectContext, context)
    }
}
