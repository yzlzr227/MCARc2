//
//  RegistionStep1VCViewController.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/5/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "RegistionStep1VC.h"
#import "RegistionStep2VC.h"

@interface RegistionStep1VC ()
@property (strong, nonatomic) IBOutlet UIImageView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *nextStep;
@property (strong, nonatomic) NSMutableDictionary *userInfo;
@property (strong, nonatomic) IBOutlet UITextField *userNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordLabel;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneLabel;

@end

@implementation RegistionStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.image = [UIImage imageNamed:@"registionProgress1"];
    self.nextStep.layer.cornerRadius = 6;
    self.userInfo = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextButtonAction:(UIButton *)sender {
    NSString *username = self.userNameLabel.text;
    NSString *password = self.passwordLabel.text;
    NSString *password2 = self.confirmPasswordLabel.text;
    NSString *phoneNumber = self.phoneLabel.text;
    
    if (username != nil
        && password != nil
        && password2 != nil
        && phoneNumber != nil
        && [password2 isEqualToString:password]) {
        [self.userInfo setValue:username forKey:@"username"];
        [self.userInfo setValue:password forKey:@"password"];
        [self.userInfo setValue:phoneNumber forKey:@"Phone"];
        [self performSegueWithIdentifier:@"to step 2" sender:self];
         }else{
        NSLog(@"Can not regist");
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[RegistionStep2VC class]]) {
        RegistionStep2VC *vc = (RegistionStep2VC *)segue.destinationViewController;
        vc.userInfo = self.userInfo;
    }
}


@end
