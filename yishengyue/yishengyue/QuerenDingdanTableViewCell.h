//
//  QuerenDingdanTableViewCell.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/1.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuerenDingdanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
@property (weak, nonatomic) IBOutlet UITextView *titleTxtview;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldpriceLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;

@end
