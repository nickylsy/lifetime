//
//  UndercarriageDetailController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/26.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UndercarriageDetailController : UIViewController

@property(copy,nonatomic)NSString *shopID;
@property (weak, nonatomic) IBOutlet UIImageView *picImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *usernameLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *undercarriageTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@end
