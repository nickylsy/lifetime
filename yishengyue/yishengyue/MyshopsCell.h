//
//  MyshopsCell.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/13.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    MyshopStateSelling,
    MyshopStateUndercarriage
} MyshopState;


@interface MyshopsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIImageView *picImg;
@property (weak, nonatomic) IBOutlet UILabel *xiajiaLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiajiaBtn;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *xiangqingBtn;


-(void)setState:(MyshopState)state;

@end
