import SwiftUI

struct AddPiggyBankView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var goal: String = ""

    var body: some View {
        VStack {
            
            PiggyBankAnimationView()
                .frame(width: 300, height: 300)
            
            Form {
                TextField("Piggy Bank Name", text: $name)
                TextField("Goal Amount", text: $goal)
                    .keyboardType(.decimalPad)
                    
                
                Button("Save") {
                    if let goalValue = Double(goal), !name.isEmpty {
                        addPiggyBank(name: name, goal: goalValue, context: viewContext)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(name.isEmpty || goal.isEmpty)
                .buttonStyle(.automatic)
            }
            .navigationTitle("Set a new goal")
        }
    }
}

struct AddPiggyBankView_Previews: PreviewProvider {
    static var previews: some View {
        let previewController = PersistenceController(inMemory: true)
        AddPiggyBankView()
            .environment(\.managedObjectContext, previewController.container.viewContext)
    }
}
