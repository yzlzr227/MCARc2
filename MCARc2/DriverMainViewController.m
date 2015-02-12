//
//  DriverMainViewController.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/7/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "DriverMainViewController.h"
#import "ViewController.h"
#import "OrderCenterVC.h"

@interface DriverMainViewController ()<UIAlertViewDelegate>

@end

@implementation DriverMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self draw];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Order\nCenter"] &&
        [segue.destinationViewController isKindOfClass:[OrderCenterVC class]]) {
        OrderCenterVC *vc = (OrderCenterVC *)segue.destinationViewController;
        vc.driverID = self.driverID;
    }
    
}

#pragma mark -- Button Actions

- (IBAction)logout:(UIBarButtonItem *)sender {
    [self addAlert];
}

- (void)addAlert{
    UIAlertView *logoutAlertView = [[UIAlertView alloc] initWithTitle:@"Logout?"
                                                              message:@"Are you sure you want to logout?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Logout", nil];
    [logoutAlertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"Logout Segue" sender:self];
    }
}



#pragma mark --draw the components
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define SCREEN_WIDTH self.view.bounds.size.width
#define SCREEN_HEIGHT self.view.bounds.size.height
- (void)draw{
    //set the photo
    UIImage *photo = [UIImage imageNamed:@"driverPhoto"];
    [self drawDriverPhoto:photo];
    //self.photoImageView.backgroundColor = [UIColor blackColor];
    //set the name label
    if ([UIScreen mainScreen].bounds.size.height > 500) {
        NSString *driverName = (self.driver.name == NULL ? @"Zhuoran Li" : self.driver.name);
        [self drawNameLabel:driverName];
    }
    [self drawInfoLabelsWithOrderNumber:(self.driver == NULL ? 20 : (int)self.driver.finishedOrders.longValue)
                               goodRate:(self.driver == NULL ? 0.9999 : self.driver.rate.floatValue)
                                   rank:(self.driver == NULL ? 123 : self.driver.rank.integerValue)];
    [self drawButtons];
}


-(void)drawButtons{
    CGFloat screenMid = SCREEN_HEIGHT / 2;
    
    UIButton *finihedOrdersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    finihedOrdersButton.frame = CGRectMake(SCREEN_WIDTH / 9, screenMid + 40, SCREEN_WIDTH /3, SCREEN_WIDTH / 5);
    [self adjustButtonShape:finihedOrdersButton WithString:@"Finished Orders" inLines:2];
    
    UIButton *orderCenterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    orderCenterButton.frame = CGRectMake(SCREEN_WIDTH * 5 / 9, screenMid + 40, SCREEN_WIDTH /3, SCREEN_WIDTH / 5);
    [self adjustButtonShape:orderCenterButton WithString:@"Order Center" inLines:2];
    
    UIButton *instructionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    instructionButton.frame = CGRectMake(SCREEN_WIDTH / 9, screenMid + 50 + SCREEN_WIDTH / 5 , SCREEN_WIDTH /3, SCREEN_WIDTH / 5);
    [self adjustButtonShape:instructionButton WithString:@"Instructions" inLines:1];
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingButton.frame = CGRectMake(SCREEN_WIDTH * 5 / 9, screenMid + 50 + SCREEN_WIDTH / 5 , SCREEN_WIDTH /3, SCREEN_WIDTH / 5);
    [self adjustButtonShape:settingButton WithString:@"Setting" inLines:1];
}

- (void)adjustButtonShape:(UIButton*)button WithString:(NSString *)title inLines:(int)numeberOfLines{
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = numeberOfLines;
    button.layer.cornerRadius = 6;
    [button.layer setMasksToBounds:YES];
    button.titleLabel.textAlignment = UITextAlignmentCenter;
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

}

-(IBAction)buttonPressed:(id)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;
        NSString *title = button.titleLabel.text;
        if (title) {
            [self performSegueWithIdentifier:title sender:self];
        }else{
            NSLog(@"no title");
        }
    }else{
        NSLog(@"Not a button");
    }
}


- (void) drawDriverPhoto:(UIImage *)driverPhoto{
    CGRect photoFrameRect = CGRectMake(SCREEN_WIDTH * 0.25, NAVIGATION_BAR_HEIGHT + 20, SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.5);
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:photoFrameRect];
    photoImageView.clipsToBounds = YES;
    [photoImageView.layer setMasksToBounds:YES];
    photoImageView.layer.cornerRadius = 6;
    photoImageView.image = driverPhoto;
    photoImageView.backgroundColor = self.view.backgroundColor;
    [photoImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:photoImageView];
}

-(void) drawNameLabel:(NSString *)name{
    CGRect labelRect = CGRectMake(0, SCREEN_WIDTH * 0.5 + NAVIGATION_BAR_HEIGHT + 20, SCREEN_WIDTH, 30);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:labelRect];
    nameLabel.text = name;
    [self adjustLabel:nameLabel];

}

- (void) drawInfoLabelsWithOrderNumber:(int)orderNumber
                              goodRate:(float)goodRate
                                  rank:(long)rank{
    CGFloat screenMid = SCREEN_HEIGHT / 2;
    
    CGRect label_1_1 = CGRectMake(0, screenMid - 30, SCREEN_WIDTH / 3, 30);
    UILabel *finishWordLabel = [[UILabel alloc] initWithFrame:label_1_1];
    finishWordLabel.text = @"Finished";
    [self adjustLabel:finishWordLabel];
    
    CGRect label_1_2 = CGRectMake(SCREEN_WIDTH / 3, screenMid - 30, SCREEN_WIDTH / 3, 30);
    UILabel *rateWordLabel = [[UILabel alloc] initWithFrame:label_1_2];
    rateWordLabel.text = @"Good Rate";
    [self adjustLabel:rateWordLabel];

    
    CGRect label_1_3 = CGRectMake(SCREEN_WIDTH * 2 / 3, screenMid - 30, SCREEN_WIDTH / 3, 30);
    UILabel *rankWordLabel = [[UILabel alloc] initWithFrame:label_1_3];
    rankWordLabel.text = @"Rank";
    [self adjustLabel:rankWordLabel];

    
    CGRect label_2_1 = CGRectMake(0, screenMid, SCREEN_WIDTH / 3, 30);
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:label_2_1];
    finishLabel.text = [NSString stringWithFormat:@"%d", orderNumber];
    [self adjustLabel:finishLabel];

    
    CGRect label_2_2 = CGRectMake(SCREEN_WIDTH / 3, screenMid, SCREEN_WIDTH / 3, 30);
    UILabel *rateLabel = [[UILabel alloc] initWithFrame:label_2_2];
    rateLabel.text = [NSString stringWithFormat:@"%.1f%@", goodRate * 100, @"%"];
    [self adjustLabel:rateLabel];

    
    CGRect label_2_3 = CGRectMake(SCREEN_WIDTH * 2 / 3, screenMid, SCREEN_WIDTH / 3, 30);
    UILabel *rankLabel = [[UILabel alloc] initWithFrame:label_2_3];
    rankLabel.text = [NSString stringWithFormat:@"%ld", rank];
    [self adjustLabel:rankLabel];
}

-(void)adjustLabel:(UILabel *)label{
    [label.layer setMasksToBounds:YES];
    label.layer.cornerRadius = 6;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}





@end














