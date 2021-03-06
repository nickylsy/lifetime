//
//  LL_GoodsDetail.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/3.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LL_GoodsDetail : NSObject
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *price;
@property(copy,nonatomic)NSString *content;
@property(retain,nonatomic)NSArray *bannerImages;
@property(copy,nonatomic)NSString *userPhoneNum;
@property(copy,nonatomic)NSString *username;

+(id)detailWithDict:(NSDictionary *)dict;
-(id)initWithDict:(NSDictionary *)dict;
@end
