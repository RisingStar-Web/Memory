//
//  NSManagedObject+ActiveRecord.m
//
//  Adapted from https://github.com/magicalpanda/MagicalRecord
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//
//  Created by Chad Podoski on 3/18/11.
//

#import <objc/runtime.h>
#import "NSManagedObject.h"
#import "DKObjectManager.h"


@implementation NSManagedObject (NSManagedObject)

// -------------------------------------------------------------------------------

+ (NSManagedObjectContext *) currentContext; {
    return [self managedObjectContext];
}

// -------------------------------------------------------------------------------

+ (NSManagedObjectContext *) managedObjectContext {
	return [[[DKObjectManager sharedManager] objectStore] managedObjectContext];
}

// -------------------------------------------------------------------------------

+ (NSEntityDescription *) entity {
	NSString *className = [NSString stringWithCString:class_getName([self class]) encoding:NSASCIIStringEncoding];
	return [NSEntityDescription entityForName:className inManagedObjectContext:[self managedObjectContext]];
}

// -------------------------------------------------------------------------------

+ (NSFetchRequest *) fetchRequest {
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [self entity];
	[fetchRequest setEntity:entity];
	return fetchRequest;
}

// -------------------------------------------------------------------------------

+ (NSArray *) objectsWithFetchRequest:(NSFetchRequest *) fetchRequest {
	NSError* error = nil;
	NSArray* objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	if (objects == nil) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}
	return objects;
}

// -------------------------------------------------------------------------------

+ (NSArray *) objectsWithPredicate:(NSPredicate *) predicate {
	NSFetchRequest *fetchRequest = [self fetchRequest];
	[fetchRequest setPredicate:predicate];
	return [self objectsWithFetchRequest:fetchRequest];
}

// -------------------------------------------------------------------------------

+ (id) firstObjectWithPredicate:(NSPredicate *) predicate {
    NSArray *objects = [[self class] objectsWithPredicate:predicate];
    if ([objects count] != 0) {
        return [objects objectAtIndex:0];
    }
    return nil;
}

// -------------------------------------------------------------------------------

+ (NSArray *) allObjects {
	return [self objectsWithPredicate:nil];
}

// -------------------------------------------------------------------------------

+ (id) object {
	id object = [[self alloc] initWithEntity:[self entity] 
        insertIntoManagedObjectContext:[self managedObjectContext]];
	return [object autorelease];
}

// -------------------------------------------------------------------------------

- (BOOL) deleteInContext:(NSManagedObjectContext *) context {
	[context deleteObject:self];
    [[[DKObjectManager sharedManager] objectStore] save];
	return YES;
}

// -------------------------------------------------------------------------------

- (BOOL) deleteEntity {
	[self deleteInContext:[[self class] currentContext]];
	return YES;
}

// -------------------------------------------------------------------------------

@end
