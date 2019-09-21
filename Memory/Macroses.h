//
//  Macroses.h
//  PickAndRoll
//
//  Created by macuser on 08.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define DocDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define CacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define LogRect(comment, frame) NSLog(@"%@ - x: %f, y: %f, w: %f, h: %f", comment, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
#define LogSize(comment, size) NSLog(@"%@ - w: %f, h: %f", comment, size.width, size.height)
#define LogPoint(comment, point) NSLog(@"%@ - x: %f, y: %f", comment, point.x, point.y)
#define Radians(degrees) ((degrees * M_PI) / 180.0)

#define IOS_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
