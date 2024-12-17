//
//  PiggyBank+CoreDataProperties.swift
//  PiggyBank
//
//  Created by Catherine Pereira on 11/27/24.
//
//

import Foundation
import CoreData


extension PiggyBank {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PiggyBank> {
        return NSFetchRequest<PiggyBank>(entityName: "PiggyBank")
    }

    @NSManaged public var name: String
    @NSManaged public var currentAmount: Double
    @NSManaged public var goal: Double
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension PiggyBank {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension PiggyBank : Identifiable {

}
