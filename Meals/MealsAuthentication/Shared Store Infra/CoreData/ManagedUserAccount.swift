//
//  ManagedUserAccount.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import CoreData

@objc(ManagedUserAccount)
class ManagedUserAccount: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var fullname: String
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var createdAt: Date
}

extension ManagedUserAccount {
    
    static func accounts(from localUserAccounts: [StoredUserAccount], in context: NSManagedObjectContext) -> NSOrderedSet {
        let images = NSOrderedSet(array: localUserAccounts.map { local in
            let managed = ManagedUserAccount(context: context)
            managed.id = local.id
            managed.fullname = local.fullname
            managed.username = local.username
            managed.password = local.password
            managed.createdAt = local.createdAt
            return managed
        })
        return images
    }
    
    var local: StoredUserAccount {
        return StoredUserAccount(id: id, fullname: fullname, username: username, password: password, createdAt: createdAt)
    }
}
