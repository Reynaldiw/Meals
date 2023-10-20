//
//  ManagedCache.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var userAccounts: NSOrderedSet
}
 
extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    var localUserAccounts: [StoredUserAccount] {
        return userAccounts.compactMap { ($0 as? ManagedUserAccount)?.local }
    }
}
