//
//  AddressCell.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/30.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *addressImg;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@end
