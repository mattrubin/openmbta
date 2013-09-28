//
//  StopsViewController.h
//  OpenMBTA
//  Created by Daniel Choi on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TripsViewController;

@interface StopsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *orderedStopNames;    
    NSString *selectedStopName;
    UITableView *tableView;
    TripsViewController *tripsViewController;
}
@property (nonatomic, strong) NSMutableArray *orderedStopNames;    
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TripsViewController *tripsViewController;
@property (nonatomic, strong) NSString *selectedStopName;
- (void)back:(id)sender;
- (void)loadStopNames:(NSMutableArray *)stopNames;
- (void)selectStopNamed:(NSString *)stopName;
@end
