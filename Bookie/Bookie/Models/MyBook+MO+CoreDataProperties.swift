//
//  MyBook+MO+CoreDataProperties.swift
//  Bookie
//
//  Created by 박제균 on 2/16/24.
//
//

import Foundation
import CoreData

extension MyBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyBook> {
        return NSFetchRequest<MyBook>(entityName: "MyBook")
    }

    @NSManaged public var author: String?
    @NSManaged public var bookDescription: String?
    @NSManaged public var coverURL: String?
    @NSManaged public var isbn13: String?
    @NSManaged public var isInWishList: Bool
    @NSManaged public var page: Int16
    @NSManaged public var publisher: String?
    @NSManaged public var title: String?

}

extension MyBook: Identifiable {

}
