#import "RoutesViewController.h"
#import "JSON.h"
#import "GetRemoteDataOperation.h"
#import "ServerUrl.h"

@interface RoutesViewController (Private)
- (void)startLoadingData;
- (void)didFinishLoadingData:(NSString *)rawData;
@end

@implementation RoutesViewController
@synthesize tableView, data, transportType, lineName, lineHeadsign, shouldReloadData;
@synthesize stopsVC;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.tableView.sectionIndexMinimumDisplayRowCount = 100;
    operationQueue = [[NSOperationQueue alloc] init];

    shouldReloadData = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.shouldReloadData) {
        self.data = nil;
        [self.tableView reloadData];
        [self startLoadingData];    
        self.shouldReloadData = NO;
    }
    if (self.lineName) {
        self.title = @"CR Trains";
    } else {
        self.title = ([self.transportType isEqualToString:@"Commuter Rail"] ? @"Rail Lines" : 
        ([self.transportType isEqualToString:@"Subway"] ? @"Subway Lines" : [NSString stringWithFormat:@"%@ Routes", self.transportType]));
    }
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                           initWithTitle:@"Refresh"
                           style:UIBarButtonItemStylePlain
                           target:self 
                           action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)reset {
    self.data = nil;
    [self.tableView reloadData];
}

- (void)dealloc {
    self.tableView = nil;
    self.data = nil;
    self.lineName = nil;
    self.lineHeadsign = nil;    
    self.transportType = nil;
    [operationQueue release];
    self.stopsVC = nil;
    [super dealloc];
}

- (void)refresh:(id)sender {
    [self startLoadingData];
}

// This calls the server
- (void)startLoadingData
{
    [self showNetworkActivity];
    NSString *apiUrl;
    //if (self.lineName == nil && self.lineHeadsign == nil) { // normal case
        apiUrl = [NSString stringWithFormat:@"%@/routes/%@", ServerURL, self.transportType];
    //} else {
     //   apiUrl = [NSString stringWithFormat:@"%@/trains?line_name=%@&line_headsign=%@", ServerURL, self.lineName, self.lineHeadsign];        
    //}
        
    NSString *apiUrlEscaped = [apiUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //NSLog(@"would call API with URL: %@", apiUrlEscaped);
    
    GetRemoteDataOperation *operation = [[GetRemoteDataOperation alloc] initWithURL:apiUrlEscaped target:self action:@selector(didFinishLoadingData:)];
    
    [operationQueue addOperation:operation];
    [operation release];
}

- (void)didFinishLoadingData:(NSString *)rawData 
{
    [self hideNetworkActivity];
    NSDictionary *rawDict = [rawData JSONValue];
    self.data = [rawDict objectForKey:@"data"];
    [self checkForMessage:rawDict];
    [self.tableView reloadData];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
    NSMutableArray *sectionTitles = [[NSMutableArray alloc] init];
    for (NSDictionary *section in self.data) {
        [sectionTitles addObject:[section objectForKey:@"route_short_name"]];
    }
    return [sectionTitles autorelease];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    NSDictionary *section = [self.data objectAtIndex:sectionIndex];
    NSArray *headsigns = [section objectForKey:@"headsigns"];
    return [headsigns count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex
{
    NSDictionary *section = [self.data objectAtIndex:sectionIndex];
    NSString *routeShortName = [section objectForKey:@"route_short_name"];
    return routeShortName;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];

    }
    if ([self.transportType isEqualToString:@"Bus"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;       // because there's an index bar 
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;        
    }
	// Configure the cell.

    NSDictionary *routeGroup = [self.data objectAtIndex:indexPath.section];
    NSArray *headsigns = [routeGroup objectForKey:@"headsigns"];
    NSArray *headsignArray = [headsigns objectAtIndex:indexPath.row];
    NSString *headsign = [headsignArray objectAtIndex:0];

    cell.textLabel.text = headsign;
    if ([self.transportType isEqualToString: @"Subway"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"from %@", [headsignArray objectAtIndex:2]];
    } else {

        NSNumber *trips_remaining = [headsignArray objectAtIndex:1];
        NSString *tripText;

        if ([trips_remaining intValue] == 0) {
            tripText = @"No more trips today";
        } else {
            NSString *pluralized = [trips_remaining intValue] == 1 ? @"trip" : @"trips";
            tripText = [NSString stringWithFormat:@"%@ more %@ today", trips_remaining, pluralized];
        }
        if ([headsignArray count] == 3 && [trips_remaining intValue] > 0) {
            // 3rd element is (+ realtime day)
            tripText = [NSString stringWithFormat:@"%@ %@", tripText, [headsignArray objectAtIndex:2]];
        }

        cell.detailTextLabel.text = tripText;
    }
    return cell;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    NSDictionary *routeGroup = [self.data objectAtIndex:indexPath.section];
    NSString *routeShortName = [routeGroup objectForKey:@"route_short_name"];
    NSArray *headsigns = [routeGroup objectForKey:@"headsigns"];
    NSArray *headsignArray = [headsigns objectAtIndex:indexPath.row];
    NSString *headsign = [headsignArray objectAtIndex:0];
    NSNumber *shouldReloadMapRegion = [NSNumber numberWithBool:YES];
    NSString *firstStop;
    if ([self.transportType isEqualToString: @"Subway"]) 
        firstStop = [headsignArray objectAtIndex:2];
    else
        firstStop = nil;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:shouldReloadMapRegion, @"shouldReloadMapRegion", self.transportType, @"transportType", routeShortName, @"routeShortName", headsign, @"headsign", firstStop, @"firstStop", nil];
    NSNotification *notification = [NSNotification notificationWithName:@"loadMBTATrips"  object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    // load stopsVC
    
    [self.navigationController pushViewController:stopsVC animated:YES];
}

@end
