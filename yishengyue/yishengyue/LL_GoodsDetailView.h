//
//  LL_GoodsDetailView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/8.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LL_GoodsDetailView : UIView<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;

-(void)setimages:(NSArray *)array;
@end
