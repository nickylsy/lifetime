//
//  CartShop.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartShop : NSObject

@property(assign,nonatomic)BOOL selected;
@property(copy,nonatomic)NSString *cartID;
@property(copy,nonatomic)NSString *shopID;
@property(copy,nonatomic)NSString *shopNum;
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *price;
@property(copy,nonatomic)NSString *banner;

+(id)cartshopWithDict:(NSDictionary *)dict;
-(id)initWithDict:(NSDictionary *)dict;
@end
