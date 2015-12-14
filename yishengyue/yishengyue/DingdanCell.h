//
//  DingdanCell.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/13.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

typedef enum DingdanState{
    DingdanStateSuccess=0,
    DingdanStateFail,
    DingdanStateWaiting,
    DingdanStatePay
}DingdanState;

#import <UIKit/UIKit.h>

@class DingdanCell;

@protocol DingdancellDelegate <NSObject>

-(void)querenshouhuo:(DingdanCell *)cell;
-(void)closeDingdan:(DingdanCell *)cell;
-(void)pay:(DingdanCell *)cell;

@end

@interface DingdanCell : UITableViewCell

@property (assign,nonatomic)DingdanState state;
@property(nonatomic,retain)id<DingdancellDelegate> mydelegate;
@property (weak, nonatomic) IBOutlet UILabel *IDLab;
@property (weak, nonatomic) IBOutlet UILabel *payStateLab;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *querenBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

-(void)setImages:(NSArray *)images;

-(void)setState:(DingdanState)state;
@end
