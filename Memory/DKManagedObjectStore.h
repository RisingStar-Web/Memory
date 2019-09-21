//
//  DKManagedObjectStore.h
//  Memory
//
//  Created by macuser on 16.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject.h"


@interface DKManagedObjectStore : NSObject {
    
    NSString *_storeFilename;
	NSString *_pathToStoreFile;
    NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel   *_managedObjectModel;
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    
    UIManagedDocument *_document;
}

// The filename of the database backing this object store
@property (nonatomic, readonly) NSString *storeFilename;

// The full path to the database backing this object store
@property (nonatomic, readonly) NSString *pathToStoreFile;

// Core Data
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) UIManagedDocument *document;

/*
 * This returns an appropriate managed object context for this object store.
 * Because of the intrecacies of how Core Data works across threads it returns
 * a different NSManagedObjectContext for each thread.
 */
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;


/**
 * Initialize a new managed object store with a SQLite database with the filename specified
 */
+ (DKManagedObjectStore *) objectStoreWithStoreFilename:(NSString *) storeFilename;
- (id) initWithStoreFilename:(NSString *) storeFilename;

/**
 * Retrieves a model object from the object store given a Core Data entity
 */
- (NSManagedObject *) createInstanceOfEntity:(NSEntityDescription *) entity;

/**
 * Save the current contents of the managed object store
 */
- (NSError *) save;

/**
 * This deletes and recreates the managed object context and 
 * persistant store, effectively clearing all data
 */
//- (void) deletePersistantStore;

- (NSManagedObjectContext *) managedObjectContext;

@end
