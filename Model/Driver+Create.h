//
//  Driver+Create.h
//  MCARc2
//
//  Created by Zhuoran Li on 12/10/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "Driver.h"

@interface Driver (Create)
//+ (Driver *)createNewDriverWithName:(NSString *)name
//                driverLicenseID:(NSString *)licenseID
//                    phoneNumber:(NSString *)phoneNumber
//           vehicalLicenseNumber:(NSString *)vehicalLicenseNumber
//         inManagedObjectContext:(NSManagedObjectContext *)context;
+(Driver *)createNewDriverWithDriverInfo:(NSDictionary *)info
                   inManageObjectContext:(NSManagedObjectContext *)context;
@end
