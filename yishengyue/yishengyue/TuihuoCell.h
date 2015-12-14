//
//  TuihuoCell.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/20.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuihuoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *IDLab;
@property (weak, nonatomic) IBOutlet UILabel *payStateLab;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImg;
@property (weak, nonatomic) IBOutlet UITextView *nameTxt;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;


@end
