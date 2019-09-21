//
//  RKManagedObject+ActiveRecord.h
//
//  Adapted from https://github.com/magicalpanda/MagicalRecord
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//
//  Created by Chad Podoski on 3/18/11.
//

#import <CoreData/CoreData.h>


@interface NSManagedObject (NSManagedObject)

+ (NSManagedObjectContext *) currentContext;

/**
 * The Core Data managed object context from the RKObjectManager's objectStore
 * that is managing this model
 */
+ (NSManagedObjectContext *) managedObjectContext;

/**
 *	The NSEntityDescription for the Subclass 
 *	defaults to the subclass className, may be overridden
 */
+ (NSEntityDescription *) entity;

/**
 *	Returns an initialized NSFetchRequest for the entity, with no predicate
 */
+ (NSFetchRequest *) fetchRequest;

/**
 * Fetches all objects from the persistent store identified by the fetchRequest
 */
+ (NSArray *) objectsWithFetchRequest:(NSFetchRequest *) fetchRequest;

/**
 * Fetches all objects from the persistent store by constructing a fetch request and
 * applying the predicate supplied. A short-cut for doing filtered searches on the objects
 * of this class under management.
 */
+ (NSArray *) objectsWithPredicate:(NSPredicate *) predicate;
+ (id) firstObjectWithPredicate:(NSPredicate *) predicate;

/**
 * Fetches all managed objects of this class from the persistent store as an array
 */
+ (NSArray *) allObjects;

/**
 *	Creates a new managed object and inserts it into the managedObjectContext.
 */
+ (id) object;

- (BOOL) deleteEntity;
- (BOOL) deleteInContext:(NSManagedObjectContext *)context;

@end
