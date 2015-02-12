//
//  MapViewController.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/12/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()<MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKRoute *currentRoute;
@property (strong, nonatomic) MKPolyline *routeOverlay;
@end


@implementation MapViewController
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define SCREEN_WIDTH self.view.bounds.size.width
#define SCREEN_HEIGHT self.view.bounds.size.height
-(void)viewDidLoad{
    [super viewDidLoad];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
    [self.view addSubview:self.mapView];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    [self setUpLocationManager];
}

#pragma mark - setUp CLLocationManager
- (void)setUpLocationManager{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    [self setLocationAccuracyBestDistanceFilterNone];
    
}

- (void)setLocationAccuracyBestDistanceFilterNone {
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
}


#pragma mark - MKMapViewDelegate methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *cllocation = [locations lastObject];
    CLLocationCoordinate2D location = [cllocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 500, 500);
    //NSLog(@"1");
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    [manager stopUpdatingLocation];
}

//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    CLLocationCoordinate2D location = [userLocation coordinate];
//    
//    //********** maybe need to be changed**************
//    [self.locationManager stopUpdatingLocation];
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 500, 500);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//}

#pragma mark - overlay methods

-(void) plotRouteOnMap:(MKRoute *)route{
    if (_currentRoute) {
        [self.mapView removeOverlay:self.routeOverlay];
    }
    
    self.routeOverlay = route.polyline;
    [self.mapView addOverlay:self.routeOverlay];
}

#pragma mark - MKMapViewDelegate methods
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return renderer;
}
@end
