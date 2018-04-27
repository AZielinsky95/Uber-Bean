//
//  NetworkManager.m
//  Uber Bean
//
//  Created by Alejandro Zielinsky on 2018-04-27.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

#import "NetworkManager.h"
#import "Cafe.h"
@implementation NetworkManager


+(void)fetchYelpDataAtCoordinates:(CLLocation*)location block:(void(^)(NSArray* cafes))blockName
{
     NSString *urlString = [NSString stringWithFormat:@"https://api.yelp.com/v3/businesses/search?term=cafe&latitude=%f&longitude=%f", location.coordinate.latitude, location.coordinate.longitude];
    
    NSURL *url =  [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request addValue:@"Bearer PIFPJFpQiP0hdiwo4AgeG4IKy0B6NXlyzOLdVgFgewxXR-9kmRhG3WVopBVY-L-XtXZcjc2pk1C0z3GF8r470KHI8StXKSSqJxVvKR9hHlN2an_0pwY6y6K7qm3jWnYx" forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionTask *task  = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                              completionHandler:^(NSData * _Nullable data,
                                                                                  NSURLResponse * _Nullable response, NSError * _Nullable error)
                               {
                                   NSLog(@"got result");
                                   NSError *error2;
                                   NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error2];
                                   
                                   
                                   NSArray *allCafes = results[@"businesses"];
                                   NSMutableArray *cafes = [[NSMutableArray alloc] init];
                                   
                                   for(int i = 0; i < [allCafes count]; i++)
                                   {
                                       [cafes addObject:allCafes[i]];
                                   }
                                   
                                   NSMutableArray *cafeArray = [[NSMutableArray alloc] init];
                                   for(NSDictionary* item in cafes)
                                   {
                                       Cafe *cafe = [[Cafe alloc] initWithData:item];
                                       [cafeArray addObject:cafe];
                                   }
                
                                   blockName(cafeArray);
                               }];
    
    [task resume];
}
@end
