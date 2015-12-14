//
//  HomeFuncView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFuncItem.h"

@interface HomeFuncView : UIView

@property(retain,nonatomic)HomeFuncItem *introduce;
@property(copy,nonatomic)void(^introduceblock)(int tag);

@property(retain,nonatomic)HomeFuncItem *quanjing;
//@property(copy,nonatomic)void(^quanjingblock)(int tag);

@property(retain,nonatomic)HomeFuncItem *jingpin;
//@property(copy,nonatomic)void(^jingpinblock)(int tag);

@property(retain,nonatomic)HomeFuncItem *kanfang;
@property(copy,nonatomic)void(^kanfangblock)(int tag);

@property(retain,nonatomic)HomeFuncItem *map;
@property(copy,nonatomic)void(^mapblock)(int tag);

@property(retain,nonatomic)HomeFuncItem *messagecenter;
@property(copy,nonatomic)void(^messagecenterblock)(int tag);


-(instancetype)initWithFrame:(CGRect)frame;

@end
