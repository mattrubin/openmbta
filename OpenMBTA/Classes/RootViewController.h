//
//  RootViewController.h
//  OpenMBTA
//
//  Created by Daniel Choi on 10/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BaseViewController.h"
#import "TripsViewController.h"
@class RoutesViewController;
@class TAlertsViewController;
@class TweetsViewController;

// note this controller doesn't need to be a subclass of BaseViewC
@interface RootViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
    RoutesViewController *routesViewController;
    TAlertsViewController *tAlertsViewController;
    TweetsViewController *tweetsViewController;
    TripsViewController *tripsViewController;
    NSOperationQueue *operationQueue;
    NSArray *menu;
    NSArray *menu2;    
    NSArray *bookmarks;
}

@property (nonatomic, strong) TripsViewController *tripsViewController;
@property (nonatomic,strong) NSArray *menu;
@property (nonatomic,strong) NSArray *menu2;
@property (nonatomic,strong) NSArray *bookmarks;
@property (nonatomic,strong) UITableView *tableView;
- (void)loadLastViewedTrip;

@end
