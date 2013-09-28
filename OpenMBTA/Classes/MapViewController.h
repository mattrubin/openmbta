//
//  MapViewController.h
//  OpenMBTA
//
//  Created by Daniel Choi on 9/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class TripsViewController;
@class StopAnnotation;

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    TripsViewController *tripsViewController;
    MKMapView *mapView;
    NSMutableArray *stopAnnotations;
    StopAnnotation *selectedStopAnnotation;
    NSString *selectedStopName;
    NSTimer *triggerCalloutTimer;
    CLLocation *location;
    MKCoordinateRegion initialRegion;
    BOOL zoomInOnSelect;

}
@property (nonatomic, strong) TripsViewController *tripsViewController;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *stopAnnotations;
@property (nonatomic, strong) StopAnnotation *selectedStopAnnotation;
@property (nonatomic, strong) NSTimer *triggerCalloutTimer;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *selectedStopName;
@property MKCoordinateRegion initialRegion;
- (void)prepareMap:(NSDictionary *)regionInfo;
- (void)annotateStops:(NSDictionary *)stops imminentStops:(NSArray *)imminentStops firstStops:(NSArray *)firstStops isRealTime:(BOOL)isRealTime;
- (NSString *)stopAnnotationTitle:(NSArray *)nextArrivals isRealTime:(BOOL)isRealTime; 
- (void)findNearestStop;
- (void)highlightStopNamed:(NSString *)stopName;
- (void)triggerCallout:(NSDictionary *)info;


@end
