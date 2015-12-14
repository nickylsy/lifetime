//
//  FenleiView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FenleiViewDelegate <NSObject>

-(void)searchFenlei:(UITapGestureRecognizer *)gesture;

@end

@interface FenleiView : UIView

@property(retain,nonatomic)id<FenleiViewDelegate> mydelegate;

-(id)initWithOrigin:(CGPoint)origin width:(CGFloat)width items:(NSArray *)items delegate:(id<FenleiViewDelegate>)delegate;

@end
