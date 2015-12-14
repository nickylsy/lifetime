//
//  LL_Goods.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/3.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LL_Goods : NSObject
@property(copy,nonatomic)NSString *ID;
@property(copy,nonatomic)NSString *userID;
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *price;
@property(copy,nonatomic)NSString *createTime;
@property(copy,nonatomic)NSString *pic;

+(id)goodsWithDict:(NSDictionary *)dict;
-(id)initWithDict:(NSDictionary *)dict;
@end
