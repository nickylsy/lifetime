//
//  HomeAirvalueView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeAirvalueView : UIView
@property (weak, nonatomic) IBOutlet UILabel *pm25State;
@property (weak, nonatomic) IBOutlet UILabel *pm25Num;
@property (weak, nonatomic) IBOutlet UILabel *pm25Name;
@property (weak, nonatomic) IBOutlet UIImageView *pm25Img;

@property (weak, nonatomic) IBOutlet UILabel *jiaquanState;
@property (weak, nonatomic) IBOutlet UILabel *jiaquanNum;
@property (weak, nonatomic) IBOutlet UILabel *jiaquanName;
@property (weak, nonatomic) IBOutlet UIImageView *jiaquanImg;

@property (weak, nonatomic) IBOutlet UILabel *wenduState;
@property (weak, nonatomic) IBOutlet UILabel *wenduNum;
@property (weak, nonatomic) IBOutlet UILabel *wenduName;
@property (weak, nonatomic) IBOutlet UIImageView *wenduImg;

@property (weak, nonatomic) IBOutlet UILabel *shiduState;
@property (weak, nonatomic) IBOutlet UILabel *shiduNum;
@property (weak, nonatomic) IBOutlet UILabel *shiduName;
@property (weak, nonatomic) IBOutlet UIImageView *shiduImg;
@end
