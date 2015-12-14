//
//  DingdanCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/13.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "DingdanCell.h"
#import "Mydefine.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+Rectbutton.h"

@implementation DingdanCell

- (void)awakeFromNib {
    // Initialization code
    
    self.centerView.layer.masksToBounds=YES;
    self.centerView.layer.borderWidth=1;
    self.centerView.layer.cornerRadius=2.0;
    self.centerView.layer.borderColor=UIColorFromRGB(0xe8e8e8).CGColor;
    
    [self.querenBtn setcornerRadius:5.0];
    [self.cancelBtn setcornerRadius:5.0];
    [self.payBtn setcornerRadius:5.0];

    [self.querenBtn addTarget:self action:@selector(querenshouhuo) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(closedingdan) forControlEvents:UIControlEventTouchUpInside];
    [self.payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    self.IDLab.textColor=UIColorFromRGB(FONT_COLOR_VALUE);
    self.payStateLab.textColor=self.IDLab.textColor;    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImages:(NSArray *)images
{
    CGFloat itemWidth=80.0;
    for (int i=0; i<images.count; i++) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(i*itemWidth, 8, itemWidth, itemWidth)];
        [self.scrollview addSubview:view];
        
        NSDictionary *dict=images[i];
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth-20, itemWidth-20)];
        imageview.center=CGPointMake(itemWidth/2, itemWidth/2);
        [imageview setImageWithURL:[NSURL URLWithString:dict[@"Banner"]]];
        [view addSubview:imageview];
    }
    
    self.scrollview.contentSize=CGSizeMake(images.count*itemWidth, itemWidth);
}

-(void)setState:(DingdanState)state
{
    _state=state;
    switch (state) {
        case DingdanStateFail:
        {
            self.payBtn.hidden=YES;
            self.querenBtn.hidden=YES;
            self.cancelBtn.hidden=YES;
            break;
        }
        case DingdanStateSuccess:
        {
            self.payBtn.hidden=YES;
            self.querenBtn.hidden=YES;
            self.cancelBtn.hidden=YES;
            break;
        }
        case DingdanStatePay:
        {
            self.payBtn.hidden=YES;
            self.querenBtn.hidden=NO;
            self.cancelBtn.hidden=YES;
            break;
        }
        case DingdanStateWaiting:
        {
            self.payBtn.hidden=NO;
            self.querenBtn.hidden=YES;
            self.cancelBtn.hidden=NO;
            break;
        }
        default:
            break;
    }
}

-(void)querenshouhuo
{
    if ([self.mydelegate respondsToSelector:@selector(querenshouhuo:)]) {
        [self.mydelegate querenshouhuo:self];
    }
}

-(void)closedingdan
{
    if ([self.mydelegate respondsToSelector:@selector(closeDingdan:)]) {
        [self.mydelegate closeDingdan:self];
    }
}

-(void)pay
{
    if ([self.mydelegate respondsToSelector:@selector(pay:)]) {
        [self.mydelegate pay:self];
    }
}

@end
