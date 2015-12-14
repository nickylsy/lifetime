//
//  AddressInfo.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject
@property(copy,nonatomic)NSString *ID;
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *phoneNum;
@property(copy,nonatomic)NSString *postalcode;
@property(copy,nonatomic)NSString *address;

+(id)addressinfoWithDict:(NSDictionary *)dict;
-(id)initWithDict:(NSDictionary *)dict;
@end
