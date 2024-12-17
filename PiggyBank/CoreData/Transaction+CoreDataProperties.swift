//
//  Transaction+CoreDataProperties.swift
//  PiggyBank
//
//  Created by Catherine Pereira on 11/27/24.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date
    @NSManaged public var note: String?
    @NSManaged public var piggyBank: PiggyBank?

}

extension Transaction : Identifiable {

}
