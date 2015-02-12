//
//  RegistionStep2VC.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/5/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "RegistionStep2VC.h"
#import "RegistionStep3VC.h"

@interface RegistionStep2VC ()
@property (strong, nonatomic) IBOutlet UIImageView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *nextStepButton;
@property (strong, nonatomic) IBOutlet UITextField *firstNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *lastNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *driverLicenseIDLabel;

@property (strong, nonatomic) IBOutlet UITextField *cardNumberLabel;
@end

@implementation RegistionStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.image = [UIImage imageNamed:@"registionProgress2"];
    self.nextStepButton.layer.cornerRadius = 6;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextStep:(UIButton *)sender {
    NSString *firstName = self.firstNameLabel.text;
    NSString *lastName = self.lastNameLabel.text;
    NSString *dlID = self.driverLicenseIDLabel.text;
    NSString *cardN = self.cardNumberLabel.text;
    if (firstName != nil &&
        lastName != nil &&
        dlID != nil &&
        cardN != nil) {
        [self.userInfo setObject:firstName forKey:@"firstname"];
        [self.userInfo setObject:lastName forKey:@"lastName"];
        [self.userInfo setObject:dlID forKey:@"driverlicenseID"];
        [self.userInfo setObject:cardN forKey:@"cardN"];
        [self performSegueWithIdentifier:@"to step 3" sender:self];
    }else{
        NSLog(@"registion error");
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[RegistionStep3VC class]]) {
        RegistionStep3VC *vc = (RegistionStep3VC *)segue.destinationViewController;
        vc.userInfo = self.userInfo;
        NSLog(@"%lu",[self.userInfo count]);
    }
    
}


@end
