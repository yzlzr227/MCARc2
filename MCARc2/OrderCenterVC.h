//
//  OrderCenterVC.h
//  MCARc2
//
//  Created by Zhuoran Li on 12/21/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCenterVC : UITableViewController
@property (strong, nonatomic) NSString *driverID;
@property (strong, nonatomic) NSMutableArray *orders;

@end
