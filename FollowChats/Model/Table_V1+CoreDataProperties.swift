//
//  Table_V1+CoreDataProperties.swift
//  
//
//  Created by Sanjay Mali on 28/12/17.
//
//

import Foundation
import CoreData


extension Table_V1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Table_V1> {
        return NSFetchRequest<Table_V1>(entityName: "Table_V1")
    }

    @NSManaged public var id: String?
    @NSManaged public var post_id: String?
    @NSManaged public var textDescrption: String?
    @NSManaged public var thumbnail_url: String?
    @NSManaged public var type: String?
    @NSManaged public var social_network_userid: String?

}
