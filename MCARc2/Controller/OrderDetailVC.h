//
//  OrderDetail.h
//  MCARc2
//
//  Created by Zhuoran Li on 12/23/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface OrderDetailVC : UIViewController

@property (strong, nonatomic) NSString *driverID;
@property (strong, nonatomic)NSDictionary *order;

@end