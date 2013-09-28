//
//  Bookmarks.m
//  OpenMBTA
//
//  Created by Daniel Choi on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Preferences.h"


@implementation Preferences

- (id)init {
    self = [super init];
    if (nil != self) { }
    return self;
}

+ (id)sharedInstance {
    static Preferences *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

- (NSMutableDictionary *)preferences {
    NSMutableDictionary *prefs;
    if ([[NSFileManager defaultManager] fileExistsAtPath: [self prefsFilePath]]) { 
        prefs = [[NSMutableDictionary alloc] initWithContentsOfFile: [self prefsFilePath]]; 
    } else {
        prefs = [[NSMutableDictionary alloc] initWithCapacity: 3];
        prefs[@"bookmarks"] = [NSMutableArray array];
    }
    return prefs;
};

NSInteger bookmarkSort(NSDictionary *bookmark1, NSDictionary *bookmark2, void *context) {
    NSComparisonResult result1 = [bookmark1[@"transportType"] compare:bookmark2[@"transportType"]];
    NSComparisonResult result2 = [bookmark1[@"routeShortName"] compare:bookmark2[@"routeShortName"]];
    NSComparisonResult result3 = [bookmark1[@"headsign"] compare:bookmark2[@"headsign"]];
    NSComparisonResult result4 = [bookmark1[@"firstStop"] compare:bookmark2[@"firstStop"]];

    if (result1 != NSOrderedSame) {
        if ([bookmark1[@"transportType"] isEqualToString:@"Boat"])
            return NSOrderedDescending;
        else if ([bookmark2[@"transportType"]  isEqualToString:@"Boat"]) 
            return NSOrderedAscending; 
        else
            return result1;
    }
    if (result2 != NSOrderedSame) {
        if ([bookmark1[@"transportType"]  isEqualToString:@"Bus"]) {
            // order numerically for Bus Routes
            int x = [bookmark1[@"routeShortName"] integerValue];
            int y = [bookmark2[@"routeShortName"] integerValue];
            if (x > y)
                return NSOrderedDescending;
            else if (x < y)
                return NSOrderedAscending;
            // skip to next if
        } else {
            return result3;
        }
    }

    if (result3 != NSOrderedSame) 
        return result3;
    return result4;
}

- (NSArray *)orderedBookmarks {
    NSArray *unorderedBookmarks = [self preferences][@"bookmarks"];
    return [unorderedBookmarks sortedArrayUsingFunction:bookmarkSort context:NULL];
}


- (NSString *) prefsFilePath { 
    NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]; 
    NSString *prefsFilePath = [cacheDirectory stringByAppendingPathComponent: @"OpenMBTAPrefs.plist"]; 
    return prefsFilePath;
} 


- (void)addBookmark:(NSDictionary *)bookmark {

    NSMutableDictionary *prefs = [self preferences];
    NSMutableArray *bookmarks = prefs[@"bookmarks"];
    [bookmarks addObject:bookmark];

    if (![prefs writeToFile:[self prefsFilePath] atomically:YES]) {
         NSLog(@"VRM failed to save preferences to file!");
    }
    //NSLog(@"added bookmark. new prefs: %@", [self preferences]);
}

- (void)removeBookmark:(NSDictionary *)bookmark {
    NSMutableDictionary *prefs = [self preferences];
    NSMutableArray *bookmarks = prefs[@"bookmarks"];
    for (NSDictionary *saved in bookmarks) {
        if ([saved[@"headsign"] isEqualToString: bookmark[@"headsign"]] &&
            [saved[@"routeShortName"] isEqualToString: bookmark[@"routeShortName"]] &&
            [saved[@"transportType"] isEqualToString: bookmark[@"transportType"]])  {
             [bookmarks removeObject:saved];
            if (![prefs writeToFile:[self prefsFilePath] atomically:YES]) {
                 NSLog(@"VRM failed to save preferences to file!");
            }

    //        NSLog(@"removed bookmark. new prefs: %@", [self preferences]);
            return;
        }
    }
}

- (BOOL)isBookmarked:(NSDictionary *)bookmark {

    NSMutableDictionary *prefs = [self preferences];
    NSArray *bookmarks = prefs[@"bookmarks"];
    
    for (NSDictionary *saved in bookmarks) {
        if ([[saved allKeys] count] == 4) {
            if ([saved[@"headsign"] isEqualToString: bookmark[@"headsign"]] &&
                [saved[@"routeShortName"] isEqualToString: bookmark[@"routeShortName"]] &&
                [saved[@"transportType"] isEqualToString: bookmark[@"transportType"]] &&
                [saved[@"firstStop"] isEqualToString: bookmark[@"firstStop"]])  {
                return true;
                }
        } else if ([[saved allKeys] count] == 3) {
            if ([saved[@"headsign"] isEqualToString: bookmark[@"headsign"]] &&
                [saved[@"routeShortName"] isEqualToString: bookmark[@"routeShortName"]] &&
                [saved[@"transportType"] isEqualToString: bookmark[@"transportType"]]) {
                    return true;
                }            
        }
        
        
    }

    return false;
}

@end
