//
//  FenleiView.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "FenleiView.h"
#import "Mydefine.h"
#import "Fenlei.h"
#import "UILabel+RectLabel.h"
@implementation FenleiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithOrigin:(CGPoint)origin width:(CGFloat)width items:(NSArray *)items delegate:(id<FenleiViewDelegate>)delegate
{
    if (self=[super init]) {
        self.backgroundColor=[UIColor whiteColor];
        
        self.mydelegate=delegate;
        
        CGFloat Ejiange=20.0;
        CGFloat Ajiange=10.0;
        //每个label更具文字内容自适应宽度
        NSMutableArray *itemLabs=[NSMutableArray array];
        for (Fenlei * item in items) {
            UILabel *itemLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
            itemLab.textAlignment=NSTextAlignmentCenter;
            itemLab.text=item.name;
            itemLab.tag=item.ID.intValue;
            itemLab.textColor=UIColorFromRGB(0x909090);
            itemLab.backgroundColor=UIColorFromRGB(0xedeeed);
//            itemLab.layer.borderColor=
//            itemLab.layer.borderWidth=1.0;
            [itemLab sizeToFit];
            [itemLab setcornerRadius:5.0 borderWidth:1 borderColor:item.ID.intValue==0?UIColorFromRGB(MAIN_COLOR_VALUE):UIColorFromRGB(0xe4e4e4)];
            [itemLabs addObject:itemLab];
            NSLog(@"%@",NSStringFromCGRect(itemLab.frame));
            UITapGestureRecognizer *fenleitap=[[UITapGestureRecognizer alloc] initWithTarget:self.mydelegate action:@selector(searchFenlei:)];
            itemLab.userInteractionEnabled=YES;
            [itemLab addGestureRecognizer:fenleitap];
            
        }
        
        //逐行添加label到self
        int row=0;
        CGFloat nowwidth=Ejiange;
        NSMutableArray *itemsInOneLine=[NSMutableArray array];
        for (UILabel *item in itemLabs) {
            nowwidth+=(item.frame.size.width+Ejiange);
            if (nowwidth<width) {
                [itemsInOneLine addObject:item];
            }else{
                nowwidth-=(item.frame.size.width+Ejiange);
                CGFloat addwith=(width-nowwidth)/itemsInOneLine.count+(itemsInOneLine.count+1)*(Ejiange-Ajiange)/itemsInOneLine.count;
                
                CGFloat x=Ajiange;
                for (int i=0; i<itemsInOneLine.count; i++) {
                    UILabel *label=itemsInOneLine[i];
                    
                    label.frame=CGRectMake(x, row*40+10, label.frame.size.width+addwith, 30);
                    x+=(label.frame.size.width+Ajiange);
                    [self addSubview:label];
                }
                row++;
                nowwidth=Ejiange;
                [itemsInOneLine removeAllObjects];
                [itemsInOneLine addObject:item];
                nowwidth+=(item.frame.size.width+Ejiange);
            }
        }
        
        //添加最后一行
        CGFloat addwith=(width-nowwidth)/itemsInOneLine.count>10.0?10.0:(width-nowwidth)/itemsInOneLine.count+(itemsInOneLine.count+1)*(Ejiange-Ajiange)/itemsInOneLine.count;
        CGFloat x=Ajiange;
        for (int i=0; i<itemsInOneLine.count; i++) {
            UILabel *label=itemsInOneLine[i];
            
            label.frame=CGRectMake(x, row*40+10, label.frame.size.width+addwith, 30);
            x+=(label.frame.size.width+Ajiange);
            [self addSubview:label];
        }
        
        UIView *shouqiView=[[UIView alloc] init];
        UIImageView *shouqiImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        shouqiImg.contentMode=UIViewContentModeScaleAspectFit;
        shouqiImg.image=[UIImage imageNamed:@"shangcheng_closefenlei.png"];
        
        UILabel *shouqiLab=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, 0, 30)];
        shouqiLab.text=@"收起分类";
        shouqiLab.textColor=UIColorFromRGB(0xd1d1d1);
        shouqiLab.font=[UIFont systemFontOfSize:13.0];
        [shouqiLab sizeToFit];
        shouqiLab.frame=CGRectMake(30, 0, shouqiLab.frame.size.width, 30);
        
        [shouqiView addSubview:shouqiImg];
        [shouqiView addSubview:shouqiLab];
        [shouqiView sizeToFit];
        shouqiView.frame=CGRectMake(0, 0, shouqiImg.frame.size.width+shouqiLab.frame.size.width, 30);
        shouqiView.center=CGPointMake(width/2.0, row*40+30+15+10);
        [self addSubview:shouqiView];
        
        self.frame=CGRectMake(origin.x, origin.y, width, row*40+30+30+10);
        self.backgroundColor=[UIColor whiteColor];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidefenlei)];
        shouqiView.userInteractionEnabled=YES;
        [shouqiView addGestureRecognizer:tap];
    }
    
    return self;
}

-(void)searchFenlei:(UITapGestureRecognizer *)gesture
{
    NSLog(@"%@",gesture);
}
-(void)hidefenlei
{
    self.superview.hidden=YES;
}
@end
