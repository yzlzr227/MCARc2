//
//  DriverMainViewController.h
//  MCARc2
//
//  Created by Zhuoran Li on 12/7/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Driver.h"

@interface DriverMainViewController : UIViewController
@property (nonatomic, strong) NSString *driverID;

@property (nonatomic, strong) Driver *driver;
@end
