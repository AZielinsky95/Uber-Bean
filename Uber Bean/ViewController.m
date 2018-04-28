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
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.mapView showAnnotations:self.cafes animated:YES];
            
            [self.mapView setRegion:MKCoordinateRegionMake(loc.coordinate,MKCoordinateSpanMake(0.005, 0.005))
                           animated:YES];
        }];
    }];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
     NSLog(@"Failed with error %@",error);
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[Cafe class]]) {
        MKMarkerAnnotationView *mark = (MKMarkerAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:MKMapViewDefaultAnnotationViewReuseIdentifier                                                                              forAnnotation:annotation];

        [mark setUserInteractionEnabled:YES];
        mark.canShowCallout = YES;
        mark.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        mark.enabled = YES;
        mark.animatesWhenAdded = YES;
    
        return mark;
    }

    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[Cafe class]])
    {

        Cafe *cafe = (Cafe *)view.annotation;
    
        UIImageView *temp = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5,50, 50)];


        [NetworkManager downloadImage:cafe.imageURL block:^(UIImage *image)
                      {
                           [NSOperationQueue.mainQueue addOperationWithBlock:^{
                               
                               temp.image = image;
                           }];
                      }];
        
        temp.contentMode = UIViewContentModeScaleAspectFit;
        
        view.leftCalloutAccessoryView = temp;
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5,75, 30)];
        subtitleLabel.text = [self ratingToStars:cafe.rating];
        view.detailCalloutAccessoryView = subtitleLabel;
    }
}

-(NSString*)ratingToStars:(NSString*)rating
{
    int numOfStars = [rating intValue];
    
    switch (numOfStars)
    {
        case 1:
           return @"⭐️";
            break;
        case 2:
           return @"⭐️⭐️";
            break;
        case 3:
            return @"⭐️⭐️⭐️";
            break;
        case 4:
            return @"⭐️⭐️⭐️⭐️";
            break;
        case 5:
            return @"⭐️⭐️⭐️⭐️⭐️";
            break;
    }
    return @"";
}

@end
