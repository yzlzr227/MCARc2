//
//  OrderCenterVC.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/21/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "OrderCenterVC.h"
#import "OrderTableViewCell.h"
#import "Order+newOrder.h"
#import "Order.h"
#import "OrderDetailVC.h"
#import "CommunicatingWithServer.h"

@interface OrderCenterVC ()

@property (strong, nonatomic) NSMutableDictionary *order;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableURLRequest *request;

@end

@implementation OrderCenterVC

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        [config setHTTPAdditionalHeaders:@{@"App": @"MCAR"}];
        
        _session = [NSURLSession sessionWithConfiguration:config];
        _url = [CommunicatingWithServer reportLocationURL];
        _request = [[NSMutableURLRequest alloc] initWithURL:_url];
        [_request setHTTPMethod:@"POST"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orders = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //[self test];
    //[self fetchOrder];
    [self reportUserInfo];
    //NSLog(@"%lu", [self.orders count]);
    //Order newOrder = [Order c]
    //[self fetchOrder];
}

-(void)test{
    self.orders  = [[NSMutableArray alloc] init];
    self.order = [[NSMutableDictionary alloc] init];
    [_order setValue:@"40.6397" forKey:@"toLati"];
    [_order setValue:@"-73.7789" forKey:@"toLong"];
    [_order setValue:@"40.6944" forKey:@"fromLati"];
    [_order setValue:@"-73.9860" forKey:@"fromLong"];
    [_order setValue:@"Poly" forKey:@"from"];
    [_order setValue:@"JFK" forKey:@"to"];
    [self.orders addObject:_order];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [self.orders count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%lu", [self.orders count]);
    static NSString *cellIdentifier = @"orderCell";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *order = self.orders[indexPath.row];
    
    cell.fromLabel.text = (NSString *)[order valueForKey:@"from"];
    cell.toLabel.text = (NSString *)[order valueForKey:@"to"];
    cell.typeImageView.image = [UIImage imageNamed:@"real"];
    return cell;
}


-(void)viewWillAppear:(BOOL)animated{
    //[self fetchOrder];
    [self reportUserInfo];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[OrderTableViewCell class]]) {
    NSLog(@"11");
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSLog(@"111");
        
            if ([segue.identifier isEqualToString:@"show detail"]) {
                NSLog(@"1111");
                if ([segue.destinationViewController isKindOfClass:[OrderDetailVC class]]) {
                    
                    OrderDetailVC *odvc = (OrderDetailVC *)segue.destinationViewController;
                    NSLog(@"!");
                    odvc.order = self.orders[indexPath.row];
                    odvc.driverID = self.driverID;
                }
            }
        
   }
}

-(void)reportUserInfo{
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
    [jsonDic setValue:@"Fetch Order" forKey:@"cmd"];
    [jsonDic setValue:self.driverID forKey:@"driverID"];
    NSError *jerror;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jerror];
    
    if (!jerror && jsonData.length > 0) {
        NSLog(@"Successful");
        //        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //        NSLog([NSString stringWithString:jsonString]);
    }else{
        NSLog(@"Parse to JSON Failed");
    }
    NSURLSessionUploadTask *uploadTask = [_session uploadTaskWithRequest:_request
                                                                fromData:jsonData
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                                                           if (!error && httpResp.statusCode == 200) {
                                                               NSLog(@"NB");
                                                               NSError *jsonError;
                                                               NSDictionary *jsonD = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                     options:NSJSONReadingMutableContainers
                                                                                                                       error:&jsonError];
                                                               NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                               int count = (int)[jsonD count];
                                                               //NSLog(@"%d", count);
                                                               for (int i = 0; i < count; i++) {
                                                                   NSString *key = [NSString stringWithFormat:@"order%d", i ];
                                                                   NSLog(@"%@", key);
                                                                   //NSLog(@"%@", [[jsonD valueForKey:key] class]);
                                                                   
                                                                   NSError *error1;
                                                                   id mid = [jsonD valueForKey:key];
                                                                   NSData *d = [mid dataUsingEncoding:NSUnicodeStringEncoding];
                                                                   NSDictionary *order = [NSJSONSerialization JSONObjectWithData:d
                                                                                                                          options:NSJSONReadingMutableContainers
                                                                                                                            error:&error1];
                                                                   if (!error1) {
                                                                       [self.orders addObject:order];
                                                                   }
                                                                   
                                                               }
                                                               NSLog(@"%lu", [self.orders count]);
                                                               [self.tableView reloadData];
                                                               
                                                           }else{
                                                               NSLog(@"FAIL");
                                                           }
                                                           [self.refreshControl endRefreshing];
                                                       }];
    
    [uploadTask resume];
    
    
}

- (IBAction)fetchOrder {
    [self.refreshControl beginRefreshing];
    [self reportUserInfo];
    [self.refreshControl endRefreshing];
}


@end






























