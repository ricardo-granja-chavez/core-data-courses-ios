//
//  Caminata+CoreDataProperties.swift
//  Caminatas
//
//  Created by Ricardo Granja Chávez on 18/05/23.
//
//

import Foundation
import CoreData


extension Caminata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Caminata> {
        return NSFetchRequest<Caminata>(entityName: "Caminata")
    }

    @NSManaged public var date: Date?
    @NSManaged public var persona: Person?

}

extension Caminata : Identifiable {

}
