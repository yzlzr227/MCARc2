//
//  Driver.h
//  MCARc2
//
//  Created by Zhuoran Li on 12/10/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Driver : NSManagedObject

@property (nonatomic, retain) NSString * licenseID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * finishedOrders;
@property (nonatomic, retain) NSNumber * acceptedOrders;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * vehicalLicenseNumber;
@property (nonatomic, retain) NSSet *orders;

@end
