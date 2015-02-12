//
//  OrderTableViewCell.m
//  MCARc2
//
//  Created by Zhuoran Li on 12/22/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

@synthesize fromLabel;
@synthesize toLabel;
@synthesize typeImageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
