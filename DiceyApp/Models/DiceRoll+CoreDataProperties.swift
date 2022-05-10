//
//  DiceRoll+CoreDataProperties.swift
//  DiceyApp
//
//  Created by Артем Ластович on 10.04.2022.
//
//

import Foundation
import CoreData


extension DiceRoll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiceRoll> {
        return NSFetchRequest<DiceRoll>(entityName: "DiceRoll")
    }

    @NSManaged public var totalRolled: Int16
    @NSManaged public var sides: Int16
    @NSManaged public var diceAmount: Int16

}

extension DiceRoll : Identifiable {

}
