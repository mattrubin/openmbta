//
//  OpenMBTAAppDelegate.h
//  OpenMBTA
//
//  Created by Daniel Choi on 10/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import <Reachability/Reachability.h>

@interface OpenMBTAAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    Reachability* hostReach;
    UIAlertView *reachabilityAlert; 
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) UIAlertView *reachabilityAlert;
- (void) showReachabilityAlert;
- (void) testReachability;

@end

