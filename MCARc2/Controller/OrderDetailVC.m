//
//  OrderDetail.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/23/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "OrderDetailVC.h"
#import "CommunicatingWithServer.h"

@interface OrderDetailVC ()<MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, MKOverlay>
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UIImageView *typeImageView;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *simulateButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentLocationCoordinate;
@property (nonatomic) CLLocationCoordinate2D startLocationCoordinate;
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
@property (strong, nonatomic) MKRoute *currentRoute;
@property (strong, nonatomic) MKPolyline *routeOverlay;
//@property (strong, nonatomic) NSMutableArray *cameras;
//@property (nonatomic) BOOL startToMoveCamera;
@property (strong, nonatomic) NSMutableArray *locationsAlongTheRoute;
//@property (strong, nonatomic) NSMutableArray *distances;
@property (strong, nonatomic) MKPointAnnotation *movingAnnotation;
//report
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation OrderDetailVC
@synthesize coordinate,boundingMapRect;


-(void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                  target:self
                                                selector:@selector(reportLocation)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)reportLocation{
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
    [jsonDic setValue:@"Update Location" forKey:@"cmd"];
    [jsonDic setValue:self.driverID forKey:@"driverID"];
    [jsonDic setValue:[NSString stringWithFormat:@"%f", self.movingAnnotation.coordinate.latitude] forKey:@"Latitute"];
    [jsonDic setValue:[NSString stringWithFormat:@"%f", self.movingAnnotation.coordinate.longitude] forKey:@"Longitude"];
    NSError *jerror;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jerror];
    
    if (!jerror && jsonData.length > 0) {
        NSLog(@"Successful");
        //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog([NSString stringWithString:jsonString]);
    }else{
        NSLog(@"Parse to JSON Failed");
    }
    NSURLSessionUploadTask *uploadTask = [_session uploadTaskWithRequest:_request
                                                                fromData:jsonData
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                                                           if (!error && httpResp.statusCode == 200) {
                                                               NSLog(@"Successfull upload");
                                                           }else{
                                                               NSLog(@"FAIL");
                                                           }
                                                       }];
    [uploadTask resume];
    
}


- (IBAction)acceptThisOrderButtonAction:(UIButton *)sender {
    [self startTimer];
    [self testLocationAnnotations];
}
- (IBAction)simulationAction:(UIButton *)sender {
    //[self getStepsCoordinats];
    [self getCoordinates];
    [self moveAnnotation:self.movingAnnotation
            withDistance:[self.locationsAlongTheRoute.firstObject distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.currentLocationCoordinate.latitude
                                                                                                                  longitude:self.currentLocationCoordinate.longitude]]];
    

}


-(void)getStepsCoordinats{
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    for (MKRouteStep *step in self.currentRoute.steps) {
        MKPolyline *line = step.polyline;
        NSUInteger pointsCount = line.pointCount;
        CLLocationCoordinate2D *routeCoordinates = malloc(pointsCount * sizeof(CLLocationCoordinate2D));
        [line getCoordinates:routeCoordinates range:NSMakeRange(0, pointsCount)];
        [locations addObject:[[CLLocation alloc] initWithLatitude:routeCoordinates[0].latitude
                                                        longitude:routeCoordinates[0].longitude]];
        [locations addObject:[[CLLocation alloc] initWithLatitude:routeCoordinates[pointsCount - 1].latitude
                                                        longitude:routeCoordinates[pointsCount - 1].longitude]];
    }
    for (int c = (int)[locations count] - 2; c >= 0; c--) {
        if (c % 2 == 0) {
            [locations removeObjectAtIndex:c];
        }
    }
    self.locationsAlongTheRoute = locations;
}

-(void)getCoordinates{
    NSUInteger pointsCount = self.routeOverlay.pointCount;
    CLLocationCoordinate2D *routeCoordinates = malloc(pointsCount * sizeof(CLLocationCoordinate2D));
    [self.routeOverlay getCoordinates:routeCoordinates range:NSMakeRange(0, pointsCount)];
    self.locationsAlongTheRoute = [[NSMutableArray alloc] initWithCapacity:pointsCount];
    for (int c = 0; c < pointsCount; c++) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:routeCoordinates[c].latitude longitude:routeCoordinates[c].longitude];
        [self.locationsAlongTheRoute addObject:location];
    }
    //[self getStepsCoordinats];
}



#pragma mark - Original Methods

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        [config setHTTPAdditionalHeaders:@{@"App": @"MCAR"}];
        
        _session = [NSURLSession sessionWithConfiguration:config];
        _url = [CommunicatingWithServer reportLocationURL];
        _request = [[NSMutableURLRequest alloc] initWithURL:_url];
        [_request setHTTPMethod:@"POST"];
    }
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    [self setUpLocationManager];
    [self prepareInfo];
    //self.timer = [[NSTimer alloc] init];
}


- (void)setUpLocationManager{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    [self setLocationAccuracyBestDistanceFilterNone];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

- (void)setLocationAccuracyBestDistanceFilterNone {
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
}

-(void) prepareInfo{
    self.fromLabel.text = [NSString stringWithFormat:@"From: %@", [self.order valueForKey:@"from"]] ;
    self.toLabel.text = [NSString stringWithFormat:@"To: %@", [self.order valueForKey:@"to"]];
    self.typeImageView.image = [UIImage imageNamed:@"real"];
    //[self testLocationAnnotations];
}

- (void) testLocationAnnotations{
    NSString *latitude = [self.order valueForKey:@"fromLati"];
    NSString *longitude =[self.order valueForKey:@"fromLong"];
    //NSLog([NSString stringWithFormat:@"%@,%@", latitude, longitude]);
    //[self.locationManager startUpdatingLocation];
    
    self.destinationCoordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
   // _currentLocationCoordinate.latitude,_currentLocationCoordinate.longitude
    
    self.startLocationCoordinate = CLLocationCoordinate2DMake(_currentLocationCoordinate.latitude,_currentLocationCoordinate.longitude);
    self.movingAnnotation = [[MKPointAnnotation alloc] init];
    self.movingAnnotation.coordinate = self.startLocationCoordinate;
    self.movingAnnotation.title = @"Vehical";
    
    MKPointAnnotation *startPointAnnotation = [[MKPointAnnotation alloc] init];
    startPointAnnotation.coordinate = self.destinationCoordinate;
    startPointAnnotation.title = @"Customer";
    latitude = [self.order valueForKey:@"toLati"];
    longitude = [self.order valueForKey:@"toLong"];
    CLLocationCoordinate2D third = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
    MKPointAnnotation *t = [[MKPointAnnotation alloc] init];
    t.coordinate = third;
    t.title = @"Destination";
    [self drawRouteFromCurrentLocationToLocation:self.destinationCoordinate];
    //[self.locationManager stopUpdatingLocation];
    [self.mapView showAnnotations:@[t,startPointAnnotation, self.movingAnnotation] animated:YES];
//    for (int i = 0; i < 1000; i++) {
//        
//    }
    
}


- (void)drawRouteFromCurrentLocationToLocation:(CLLocationCoordinate2D)coords{
    
    //path
    MKDirectionsRequest *directionRequest = [MKDirectionsRequest new];
    //MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    //make the source
    MKPlacemark *startPlaceMark = [[MKPlacemark alloc] initWithCoordinate:self.startLocationCoordinate addressDictionary:nil];
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:startPlaceMark];
    //make the destination
    MKPlacemark *destinetionPlaceMark = [[MKPlacemark alloc] initWithCoordinate:coords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinetionPlaceMark];
    [directionRequest setSource:source];
    [directionRequest setDestination:destination];
    directionRequest.transportType = MKDirectionsTransportTypeAutomobile;
    //get directions
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"can not get directions");
            return;
        }
        
        self.currentRoute =  [response.routes firstObject];
        [self plotRouteOnMap:self.currentRoute];
    }];
}

- (void)moveAnnotation:(MKPointAnnotation *)annotation withDistance:(CLLocationDistance) distance{
    if ([self.locationsAlongTheRoute count] == 0) {
        //[self reportLocation];
        [self.mapView removeAnnotation:self.movingAnnotation];
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    CLLocation *locaiton = [self.locationsAlongTheRoute firstObject];
    //NSLog(@"%f,%f", locaiton.coordinate.latitude, locaiton.coordinate.longitude);
    [self.locationsAlongTheRoute removeObjectAtIndex:0];
    CLLocationDistance nextDistance;
    if ([self.locationsAlongTheRoute count] != 0) {
        nextDistance = [self.locationsAlongTheRoute.firstObject distanceFromLocation:locaiton];
    }else{
        nextDistance = [locaiton distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.destinationCoordinate.latitude
                                                                                 longitude:self.destinationCoordinate.longitude]];
    }
    
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [annotation setCoordinate:locaiton.coordinate];
                     }
                     completion:^(BOOL finished) {
                         [self moveAnnotation:annotation withDistance:nextDistance];
                     }];
    
}




#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedFailureReason]);
    [self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"!!");
    CLLocation *cllocation = [locations lastObject];
    self.currentLocationCoordinate = [cllocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocationCoordinate, 250, 250);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    [manager stopUpdatingLocation];
}



#pragma mark - overlay methods

- (void)plotRouteOnMap:(MKRoute *)route{
    if (_currentRoute) {
        [self.mapView removeOverlay:self.routeOverlay];
    }
    
    self.routeOverlay = route.polyline;
    [self.mapView addOverlay:self.routeOverlay level:MKOverlayLevelAboveRoads];
}

#pragma mark - MKMapViewDelegate methods
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return renderer;
}


@end
