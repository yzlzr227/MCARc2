//
//  Driver+Create.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/10/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "Driver+Create.h"
#import "fetcher.h"

@implementation Driver (Create)

+(Driver *)createNewDriverWithDriverInfo:(NSDictionary *)info inManageObjectContext:(NSManagedObjectContext *)context{
    Driver *driver = nil;
    NSString *licenseID = info[DRIVER_LICENSEID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Driver"];
    request.predicate = [NSPredicate predicateWithFormat:@"licenseID = %@", licenseID];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] != 1) {
        //handle error
    }else if ([matches count]){
        driver = [matches firstObject];
    }else{
        driver = [NSEntityDescription insertNewObjectForEntityForName:@"Driver"
                                               inManagedObjectContext:context];
        driver.licenseID = licenseID;
        driver.name = info[DRIVER_NAME];
        driver.finishedOrders = info[DRIVER_FINISHEDORDERS];
        driver.acceptedOrders = info[DRIVER_ACCEPTEDORDERS];
        driver.rate = info[DRIVER_RATE];
        driver.rank = info[DRIVER_RANK];
        driver.phoneNumber = info[DRIVER_PHONENUMBER];
        driver.vehicalLicenseNumber = info[DRIVER_VECICALLICENSENUMBER];
    }

    return driver;
}

//
//+ (Driver *)createNewDriverWithName:(NSString *)name
//                driverLicenseID:(NSString *)licenseID
//                    phoneNumber:(NSString *)phoneNumber
//           vehicalLicenseNumber:(NSString *)vehicalLicenseNumber
//         inManagedObjectContext:(NSManagedObjectContext *)context{
//    Driver *driver = nil;
//    
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Driver"];
//    request.predicate = [NSPredicate predicateWithFormat:@"licenseID = %@", licenseID];
//    
//    NSError *error;
//    NSArray *matches = [context executeFetchRequest:request
//                                              error:&error];
//    if (!matches || error || [matches count] != 1) {
//        //handle error
//    }else if ([matches count]){
//        driver = [matches firstObject];
//    }else{
//        driver = [NSEntityDescription insertNewObjectForEntityForName:@"Driver"
//                                               inManagedObjectContext:context];
//        driver.licenseID = licenseID;
//        driver.name = name;
//        driver.vehicalLicenseNumber = vehicalLicenseNumber;
//        driver.phoneNumber = phoneNumber;
//    }
//    
//    
//    return driver;
//}
//
@end
