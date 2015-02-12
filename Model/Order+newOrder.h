//
//  Order+newOrder.h
//  MCARc2
//
//  Created by Zhuoran Li on 12/10/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "Order.h"

@interface Order (newOrder)
+(Order *)createNewOrderWithOrderInfo:(NSDictionary *)orderInfo
                   inManageObjectContext:(NSManagedObjectContext *)context;
@end
