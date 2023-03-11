//
//  Automovil+CoreDataProperties.swift
//  Automoviles
//
//  Created by Ricardo Granja Chávez on 11/03/23.
//
//

import Foundation
import CoreData

extension Automovil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Automovil> {
        return NSFetchRequest<Automovil>(entityName: "Automovil")
    }

    @NSManaged public var busqueda: String?
    @NSManaged public var calificacion: Double
    @NSManaged public var datosImagen: Data?
    @NSManaged public var nombre: String?
    @NSManaged public var ultimaPrueba: Date?
    @NSManaged public var vecesProbado: Int32

}

extension Automovil : Identifiable {

}
