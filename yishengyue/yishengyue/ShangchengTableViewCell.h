//
//  ShangchengTableViewCell.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/29.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShangchengTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fenleiLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *fenxiangBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shangpinImg;
@property (weak, nonatomic) IBOutlet UIView *centerview;

@end
