//
//  RegistionStep3VC.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/6/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "RegistionStep3VC.h"
#import "CommunicatingWithServer.h"

@interface RegistionStep3VC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *progressView;
@property (strong, nonatomic) IBOutlet UIImageView *vehicalImageView;
@property (strong, nonatomic) IBOutlet UITextField *plateLabel;
@property (strong, nonatomic) IBOutlet UIButton *finishRegistionButton;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableURLRequest *request;

@end
@implementation RegistionStep3VC

- (IBAction)tapToSelectPhoto:(UITapGestureRecognizer *)sender {
    [self showSelectPhotoFromSourceActionSheet];
}


-(void)showSelectPhotoFromSourceActionSheet{
    UIActionSheet *selectPhotoSourceActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select the Photo Source"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"Canael"
                                                                destructiveButtonTitle:nil
                                                                     otherButtonTitles:@"From Album", @"From Camera", nil];
    [selectPhotoSourceActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self photoFromAlbum:nil];
    }else if (buttonIndex == 1){
        [self photoFromCamera:nil];
    }
}

-(IBAction)photoFromAlbum:(id)sender{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerController.sourceType];
    }
    pickerController.delegate = self;
    pickerController.allowsEditing = NO;
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];
}

- (IBAction)finishRegistionButtonAction:(UIButton *)sender {
    NSLog(@"finish");
    NSString *plateN = self.plateLabel.text;
    if (plateN != nil && ![self.vehicalImageView.image isEqual:[UIImage imageNamed:@"providePhoto"]]) {
        NSLog(@"lalalal");
        [self.userInfo setValue:plateN forKey:@"plat"];
        [self reportUserInfo];
    }else{
        NSLog(@"Wrong");
    }
    [self addAlert];
}

- (void)addAlert{
    UIAlertView *logoutAlertView = [[UIAlertView alloc] initWithTitle:@"Finish Registion"
                                                              message:@"Are you sure you have checked the correctness of all the information you provided?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Check Again"
                                                    otherButtonTitles:@"Finish", nil];
    [logoutAlertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"Finish Registion" sender:self];
    }
}

-(void)reportUserInfo{
    //NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
    [self.userInfo setValue:@"Driver Registion" forKey:@"cmd"];
    NSError *jerror;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.userInfo
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jerror];
    
    if (!jerror && jsonData.length > 0) {
        NSLog(@"Successful");
        //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog([NSString stringWithString:jsonString]);
    }else{
        NSLog(@"Parse to JSON Failed");
    }
    NSURLSessionUploadTask *uploadTask = [_session uploadTaskWithRequest:_request
                                                                fromData:jsonData
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                                                           if (!error && httpResp.statusCode == 200) {
                                                               NSLog(@"Successfull upload");
                                                           }else{
                                                               NSLog(@"FAIL");
                                                           }
                                                       }];
    [uploadTask resume];
    
}


- (IBAction)photoFromCamera:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.allowsEditing = NO;
        pickerController.sourceType = sourceType;
        //UIView *ovarLayView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 320, 254)];
        pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [self presentViewController:pickerController animated:YES completion:^{
        }];
    }else{
        NSLog(@"No camera");
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.vehicalImageView.image = image;
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
    // Do any additional setup after loading the view.
    self.progressView.image = [UIImage imageNamed:@"registionProgress3"];
    self.finishRegistionButton.layer.cornerRadius = 6;
    self.vehicalImageView.backgroundColor = self.view.backgroundColor;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
