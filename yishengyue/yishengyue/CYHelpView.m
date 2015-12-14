//
//  CYHelpView.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/19.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "CYHelpView.h"
#import "UIView+RoundRectView.h"
#import "NSDictionary+GetObjectBykey.h"
#import "Mydefine.h"

@implementation CYHelpView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLab.textColor=UIColorFromRGB(FONT_COLOR_VALUE);
    [self setcornerRadius:5.0];
    [self.knowBtn setcornerRadius:5.0];
}

-(void)setHelpInfo:(NSArray *)array
{
    CGRect scrollFrame=self.scrollView.frame;
    scrollFrame.size.width=self.frame.size.width;
    self.scrollView.frame=scrollFrame;
    CGFloat leftmargin=10.0;
    CGFloat totalY=0.0;
    for (NSDictionary *dict in array) {
        NSString *ans=[dict getObjectByKey:ANSWER_KEY];
        NSString *qus=[dict getObjectByKey:QUESTION_KEY];
        
        UILabel *qusLab=[[UILabel alloc] initWithFrame:CGRectMake(leftmargin, totalY, self.scrollView.frame.size.width-leftmargin*2, 0)];
        qusLab.font=[UIFont boldSystemFontOfSize:15.0];
        qusLab.numberOfLines=0;
        qusLab.text=qus;
        qusLab.textColor=self.titleLab.textColor;
        [qusLab sizeToFit];
        [self.scrollView addSubview:qusLab];
        totalY+=qusLab.frame.size.height+5.0;
        
        UILabel *ansLab=[[UILabel alloc] initWithFrame:CGRectMake(leftmargin, totalY, self.scrollView.frame.size.width-leftmargin*2, 0)];
        ansLab.font=[UIFont boldSystemFontOfSize:12.0];
        ansLab.numberOfLines=0;
        ansLab.text=ans;
        ansLab.textColor=[UIColor grayColor];
        [ansLab sizeToFit];
        ansLab.textAlignment=NSTextAlignmentNatural;
        [self.scrollView addSubview:ansLab];
        totalY+=ansLab.frame.size.height+10.0;
    }
    
    self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width, totalY);
}

@end
