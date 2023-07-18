//
//  Compras+CoreDataProperties.swift
//  ShopingList
//
//  Created by Marco Alonso Rodriguez on 17/07/23.
//
//

import Foundation
import CoreData


extension Compras {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Compras> {
        return NSFetchRequest<Compras>(entityName: "Compras")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var comprado: Bool
    @NSManaged public var fecha: Date?
    @NSManaged public var articulo: String?
    @NSManaged public var imagen: Data?

}

extension Compras : Identifiable {

}
