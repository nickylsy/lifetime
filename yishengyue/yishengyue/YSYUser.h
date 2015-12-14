//
//  YSYUser.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSYUser : NSObject

@property(copy,nonatomic)NSString *ID;
@property(copy,nonatomic)NSString *username;
@property(copy,nonatomic)NSString *logoURLString;
@property(copy,nonatomic)NSString *sex;
@property(copy,nonatomic)NSString *roomNum;
@property(copy,nonatomic)NSString *idCard;
@property(copy,nonatomic)NSString *hobby;
@property(copy,nonatomic)NSString *createtime;
@property(copy,nonatomic)NSString *phoneNum;
@property(copy,nonatomic)NSString *shareCode;

+(id)userWihtDict:(NSDictionary *)dict;
-(id)initWithDict:(NSDictionary *)dict;
-(void)refreshWithDict:(NSDictionary *)dict;

-(NSMutableArray *)toArray;
@end
