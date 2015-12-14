//
//  MessageCenterCell.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/28.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *centerview;
@property (weak, nonatomic) IBOutlet UIImageView *readedImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIImageView *xuxianImg;


@end
