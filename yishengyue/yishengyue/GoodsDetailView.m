//
//  GoodsDetailView.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "GoodsDetailView.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+URLEncoding.h"

@implementation GoodsDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    self.numberView.layer.borderColor=self.fengexianImg.backgroundColor.CGColor;
    self.numberView.layer.borderWidth=1;
    self.jianBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.jiaBtn.imageView.contentMode=self.jianBtn.imageView.contentMode;
    self.scrollview.delegate=self;
}

-(void)setimages:(NSArray *)array
{
    
    self.pagecontrol.numberOfPages=array.count<2?0:array.count;
    
    CGFloat imageviewWidth=self.frame.size.width-16;//self.scrollview.frame.size.width;
    CGFloat imageviewHeight=imageviewWidth/2;//self.scrollview.frame.size.height;
    for (int i=0; i<array.count; i++) {
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(i*imageviewWidth, 0, imageviewWidth, imageviewHeight)];
        NSString *imageurlstring=array[i];
        [imageview setImageWithURL:[NSURL URLWithString:imageurlstring.URLEncodedString] placeholderImage:[UIImage imageNamed:@"picture_default_ST.jpg"]];
        [self.scrollview addSubview:imageview];
    }
    self.scrollview.contentSize=CGSizeMake(imageviewWidth*array.count,imageviewHeight);
    self.scrollview.pagingEnabled=YES;

}

- (IBAction)numberJian:(UIButton *)sender {
    if (self.numberTxt.text.intValue<2) {
        return;
    }
    
    self.numberTxt.text=[NSString stringWithFormat:@"%i",self.numberTxt.text.intValue-1];
}

- (IBAction)numberJia:(UIButton *)sender {
    self.numberTxt.text=[NSString stringWithFormat:@"%i",self.numberTxt.text.intValue+1];
}

#pragma mark - UIScrollView代理方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pagecontrol.currentPage=(int)(scrollView.contentOffset.x/scrollView.frame.size.width);
}
@end
