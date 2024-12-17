import CoreData

/// Adds a new Piggy Bank to the Core Data store
func addPiggyBank(name: String, goal: Double, context: NSManagedObjectContext) {
    // Check if a PiggyBank with the same name already exists
    let fetchRequest: NSFetchRequest<PiggyBank> = PiggyBank.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    if let existingPiggyBanks = try? context.fetch(fetchRequest), !existingPiggyBanks.isEmpty {
        print("PiggyBank with name '\(name)' already exists.")
        return
    }

    let piggyBank = PiggyBank(context: context)
    piggyBank.name = name
    piggyBank.goal = goal
    piggyBank.currentAmount = 0.0
    
    do {
        try context.save()
        print("PiggyBank '\(name)' saved successfully!")
    } catch {
        print("Error saving PiggyBank: \(error)")
    }
}


/// Adds a new Transaction to a specific Piggy Bank (supports negative values)
func addTransaction(to piggyBank: PiggyBank, amount: Double, note: String?, context: NSManagedObjectContext) {
    let transaction = Transaction(context: context)
    transaction.amount = amount
    transaction.date = Date()
    transaction.note = note
    transaction.piggyBank = piggyBank

    piggyBank.currentAmount += amount

    do {
        try context.save()
        print("Transaction saved successfully!")
    } catch {
        print("Failed to save Transaction: \(error)")
    }
}

/// Fetches all Piggy Banks from the Core Data store
func fetchPiggyBanks(context: NSManagedObjectContext) -> [PiggyBank] {
    let fetchRequest: NSFetchRequest<PiggyBank> = PiggyBank.fetchRequest()

    do {
        return try context.fetch(fetchRequest)
    } catch {
        print("Failed to fetch PiggyBanks: \(error)")
        return []
    }
}

/// Fetches all Transactions for a specific Piggy Bank
func fetchTransactions(for piggyBank: PiggyBank, context: NSManagedObjectContext) -> [Transaction] {
    guard let transactions = piggyBank.transactions as? Set<Transaction> else { return [] }
    return transactions.sorted { $0.date < $1.date }
}

/// Deletes a specific Piggy Bank and its associated Transactions
func deletePiggyBank(_ piggyBank: PiggyBank, context: NSManagedObjectContext) {
    context.delete(piggyBank)

    do {
        try context.save()
        print("PiggyBank deleted successfully!")
    } catch {
        print("Failed to delete PiggyBank: \(error)")
    }
}

/// Deletes a specific Transaction
func deleteTransaction(_ transaction: Transaction, context: NSManagedObjectContext) {
    context.delete(transaction)

    do {
        try context.save()
        print("Transaction deleted successfully!")
    } catch {
        print("Failed to delete Transaction: \(error)")
    }
}

func resetCoreDataStore() {
    let container = PersistenceController.shared.container
    let storeURL = container.persistentStoreCoordinator.persistentStores.first?.url

    if let storeURL = storeURL {
        do {
            try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
            print("Persistent store reset successfully!")
        } catch {
            print("Failed to reset persistent store: \(error)")
        }
    }
}
