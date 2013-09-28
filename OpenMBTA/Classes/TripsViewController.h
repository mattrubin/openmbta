//
//  TripsViewController.h
//  OpenMBTA
//
//  Created by Daniel Choi on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>

@class MapViewController;
@class ScheduleViewController;
@class StopsViewController;

@interface TripsViewController : BaseViewController <CLLocationManagerDelegate, ADBannerViewDelegate> {
    NSString *headsign;
    NSString *routeShortName;
    NSString *transportType;
    NSString *firstStop; // used for Subway
    BOOL shouldReloadData;
    BOOL shouldReloadRegion;
    UIView *contentView;
    NSOperationQueue *operationQueue;
    CLLocationManager *locationManager;
    CLLocation *location;
    UILabel *headsignLabel;
    UILabel *routeNameLabel;    
    NSDictionary *stops;
    NSArray *orderedStopIds;    
    NSArray *imminentStops;  
    NSArray *firstStops;
    NSDictionary *regionInfo;
    NSString *selectedStopId;
    NSMutableArray *orderedStopNames;

    MapViewController *mapViewController;
    UISegmentedControl *segmentedControl;
    NSInteger startOnSegmentIndex;
    
    ScheduleViewController *scheduleViewController;
    UIView *currentContentView;
    StopsViewController *stopsViewController;
    BOOL gridCreated;
    UIBarButtonItem *bookmarkButton; 
    BOOL bannerIsVisible;
    ADBannerView *adView;
    UIBarButtonItem *findStopButton;
    UIView *findingProgressView;

}
@property (nonatomic, copy) NSString *headsign;
@property (nonatomic, strong) NSString *routeShortName;
@property (nonatomic, strong) NSString *transportType;
@property (nonatomic, strong) NSString *firstStop;
@property (nonatomic, getter=shouldReloadData) BOOL shouldReloadData;
@property (nonatomic, getter=shouldReloadRegion) BOOL shouldReloadRegion;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) IBOutlet UILabel *headsignLabel;
@property (nonatomic, strong) IBOutlet UILabel *routeNameLabel;    
@property (nonatomic, strong) NSDictionary *stops;
@property (nonatomic, strong) NSArray *orderedStopIds;
@property (nonatomic, strong) NSArray *imminentStops;
@property (nonatomic, strong) NSArray *firstStops;
@property (nonatomic, strong) NSDictionary *regionInfo;
@property (nonatomic,copy) NSString *selectedStopId;

@property (nonatomic, strong) IBOutlet MapViewController *mapViewController;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet ScheduleViewController *scheduleViewController;
@property (nonatomic, strong) UIView *currentContentView;
@property (nonatomic, strong) IBOutlet StopsViewController *stopsViewController;
@property (nonatomic, strong) NSMutableArray *orderedStopNames;
@property (nonatomic, strong) UIBarButtonItem *bookmarkButton; 
@property (nonatomic, assign)BOOL bannerIsVisible;
@property (nonatomic, strong) ADBannerView *adView;
@property (nonatomic, assign) NSInteger startOnSegmentIndex;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *findStopButton;
@property (nonatomic, strong)   UIView *findingProgressView;

- (void)addBookmarkButton;
- (void)toggleView:(id)sender;
- (void)highlightStopNamed:(NSString *)stopName;
- (void)highlightStopPosition:(int)pos;
- (void)startLoadingData;
- (void)showStopsController:(id)sender;
- (void)reloadData:(id)sender;
- (void)toggleBookmark:(id)sender;
- (BOOL)isBookmarked;
- (IBAction)infoButtonPressed:(id)sender;

- (void)showFindingIndicators;
- (void)hideFindingIndicators;
- (void)reloadOnBecomingActive:(NSNotification *)n;


@end
