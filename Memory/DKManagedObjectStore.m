//
//  DKManagedObjectStore.m
//  Memory
//
//  Created by macuser on 16.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKManagedObjectStore.h"
#import "DKAppDelegate.h"
#import "Macroses.h"
#import "SVProgressHUD.h"

static NSString *const RKManagedObjectStoreThreadDictionaryContextKey = @"RKManagedObjectStoreThreadDictionaryContextKey";

@interface DKManagedObjectStore (Private)

- (void) createPersistentStoreCoordinator;
- (NSManagedObjectContext *) newManagedObjectContext;

@end


@implementation DKManagedObjectStore

@synthesize storeFilename              = _storeFilename;
@synthesize pathToStoreFile            = _pathToStoreFile;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext       = _managedObjectContext;
@synthesize document                   = _document;

// -------------------------------------------------------------------------------

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDocumentStateChangedNotification object:_document];
    
    [_storeFilename              release];
    [_pathToStoreFile            release];
    [_managedObjectModel         release];
    [_persistentStoreCoordinator release];
    [_managedObjectContext       release];
    [_document                   release];
    
    [super dealloc];
}

// -------------------------------------------------------------------------------

+ (DKManagedObjectStore *) objectStoreWithStoreFilename:(NSString *) storeFilename {
    return [[[self alloc] initWithStoreFilename:storeFilename] autorelease];
}

// -------------------------------------------------------------------------------

- (id)initWithStoreFilename:(NSString*)storeFilename {
    self = [super init];
    if (self) {
        _storeFilename = [storeFilename retain];
        _managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]] retain];
        _pathToStoreFile = [[DocDir stringByAppendingPathComponent:_storeFilename] retain];
        
        return [self addLocalStore:storeFilename];
    }
    return nil;
}

- (id)addLocalStore:(NSString*)storeFilename {

    NSDictionary *options;
    options = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
               [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *localURL = [fileManager URLForDirectory:NSDocumentDirectory
                                               inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    NSURL *localCoreDataURL = [localURL URLByAppendingPathComponent:self.storeFilename];
    
    self.document = [[UIManagedDocument alloc] initWithFileURL:localCoreDataURL];
    self.document.persistentStoreOptions = options;
    
    if ([fileManager fileExistsAtPath:[localCoreDataURL path]]) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            [self postRefreshNotification];
        }];
    } else {
        // Clean up the container.
        [self.document saveToURL:localCoreDataURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   
               }];
    }
    
    return self;
}

// -------------------------------------------------------------------------------

- (void) postRefreshNotification {
    NSNotification *refreshNotification = [NSNotification notificationWithName:@"RefreshAllViews"
                                                                        object:self userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:refreshNotification];
}

// -------------------------------------------------------------------------------

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {

    return [self.document.managedObjectContext persistentStoreCoordinator];
}

// -------------------------------------------------------------------------------

- (NSManagedObject *) createInstanceOfEntity:(NSEntityDescription *) entity {
    NSManagedObject *object = [[[NSManagedObject alloc] initWithEntity:entity
                                        insertIntoManagedObjectContext:self.managedObjectContext] autorelease];
    return object;
}

// -------------------------------------------------------------------------------

/**
 * Performs the save action for the application, which is to send the save:
 * message to the application's managed object context.
 */
- (NSError *) save {
	NSManagedObjectContext *moc = [self managedObjectContext];
    NSError *error = nil;
	
	@try {
		if (![moc save:&error] || ![moc.parentContext save:&error]) {
			return error;
		}
	}
	@catch (NSException *e) {
        @throw;
	}
    
	return nil;
}

// -------------------------------------------------------------------------------

- (void) saveManagedDocument {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *localURL = [fileManager URLForDirectory:NSDocumentDirectory
                                          inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    NSURL *localCoreDataURL = [localURL URLByAppendingPathComponent:self.storeFilename];
    [self.document saveToURL:localCoreDataURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
}

// -------------------------------------------------------------------------------

/**
 * Override managedObjectContext getter to ensure we return a separate context
 * for each NSThread.
 */
- (NSManagedObjectContext *) managedObjectContext {
    return [self newManagedObjectContext];
}

// -------------------------------------------------------------------------------

- (NSManagedObjectContext *) newManagedObjectContext {
    return self.document.managedObjectContext;
}

// -------------------------------------------------------------------------------

@end
