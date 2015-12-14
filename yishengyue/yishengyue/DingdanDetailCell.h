//
//  DingdanDetailCell.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/14.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DingdanDetailCell;
@protocol DingdanDetailCellDelegate <NSObject>

-(void)tuihuo:(DingdanDetailCell *)cell;

@end

@interface DingdanDetailCell : UITableViewCell

@property(nonatomic,retain)id<DingdanDetailCellDelegate> mydelegate;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImg;
@property (weak, nonatomic) IBOutlet UITextView *titleTxt;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UIButton *tuihuoBtn;

@end
