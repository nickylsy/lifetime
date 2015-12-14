//
//  GoodsDetailView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailView : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *funcBtn;
@property (weak, nonatomic) IBOutlet UILabel *funcLab;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UIButton *jianBtn;
@property (weak, nonatomic) IBOutlet UIButton *jiaBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
@property (weak, nonatomic) IBOutlet UIImageView *fengexianImg;

- (IBAction)numberJian:(UIButton *)sender;
- (IBAction)numberJia:(UIButton *)sender;
-(void)setimages:(NSArray *)array;
@end
