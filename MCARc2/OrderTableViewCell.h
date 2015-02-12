//
//  OrderTableViewCell.h
//  MCARc2
//
//  Created by Zhuoran Li on 12/22/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UIImageView *typeImageView;

@end
