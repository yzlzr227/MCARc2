//
//  Order.h
//  MCARc2
//
//  Created by Zhuoran Li on 12/10/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Driver;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSString *orderID;
@property (nonatomic, retain) NSNumber *fromLat;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber *fromLongti;
@property (nonatomic, retain) NSNumber *toLongti;
@property (nonatomic, retain) NSNumber *toLat;
@property (nonatomic, retain) NSNumber *real;
@property (nonatomic, retain) NSString *fromName;
@property (nonatomic, retain) NSString *toName;
@property (nonatomic, retain) NSNumber *fee;
@property (nonatomic, retain) NSNumber *finished;
@property (nonatomic, retain) NSNumber *rate;
@property (nonatomic, retain) Driver *whoDoThis;

@end
