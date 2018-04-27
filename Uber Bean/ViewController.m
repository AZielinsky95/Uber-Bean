//
//  ViewController.m
//  Uber Bean
//
//  Created by Alejandro Zielinsky on 2018-04-27.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "Cafe.h"
@import MapKit;
@import CoreLocation;

@interface ViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property NSArray<Cafe*> *cafes;
@end

@implementation ViewController
//43.6446447,-79.3949987,
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;
    
}



- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Authorization status: %d", status);
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [manager requestLocation];
        [manager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"Updated locations %@", locations);
    CLLocation *loc = locations[0];
    
    [NetworkManager fetchYelpDataAtCoordinates:loc block:^(NSArray *cafes)
    {
        self.cafes = cafes;
        [self.mapView showAnnotations:self.cafes animated:YES];
    }];
    
    [self.mapView
     setRegion:MKCoordinateRegionMake(loc.coordinate,
                                      MKCoordinateSpanMake(0.06, 0.06))
     animated:YES];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
     NSLog(@"Failed with error %@",error);
}

//#pragma mark - MKMapViewDelegate
//
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[Cafe class]]) {
//        MKMarkerAnnotationView *mark = (MKMarkerAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cafe"                                                                              forAnnotation:annotation];
//
//        mark.markerTintColor = [UIColor purpleColor];
//        mark.glyphText = annotation.title;
//        mark.titleVisibility = MKFeatureVisibilityVisible;
//        mark.animatesWhenAdded = YES;
//
//        return mark;
//    }
//
//    return nil;
//}

@end
