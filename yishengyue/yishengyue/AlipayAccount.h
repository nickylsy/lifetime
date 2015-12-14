//
//  AlipayAccount.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayAccount : NSObject

@property(copy,nonatomic)NSString *alipayID;
@property(copy,nonatomic)NSString *username;
@property(copy,nonatomic)NSString *account;

+(id)accountWithDict:(NSDictionary *)dict;
-(id)initWithDict:(NSDictionary *)dict;
@end
