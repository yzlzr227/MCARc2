//
//  LoginViewController.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/5/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "LoginViewController.h"
#import "CommunicatingWithServer.h"
#import "DriverMainViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSString *driverID;
@end

@implementation LoginViewController

-(void)requestLoginwithUsername:(NSString *)username withPassword:(NSString *)password{
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
    [jsonDic setValue:@"Drive Login" forKey:@"cmd"];
    [jsonDic setValue:username forKey:@"username"];
    [jsonDic setValue:password forKey:@"pass"];
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
                                                               if ([[jsonD valueForKey:@"status"] isEqualToString:@"success"]) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       self.driverID = [jsonD valueForKey:@"id"];
                                                                       [self performSegueWithIdentifier:@"to main" sender:self];
                                                                   });
                                                               }
                                                               
                                                           }else{
                                                               NSLog(@"FAIL");
                                                           }
                                                       }];
    
    [uploadTask resume];
    
}


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
    self.loginButton.layer.cornerRadius = 6;
    self.loginButton.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickLoginButton:(UIButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    [self requestLoginwithUsername:username withPassword:password];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
