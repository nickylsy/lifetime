//
//  Fenlei.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fenlei : NSObject
@property(copy,nonatomic)NSString *ID;
@property(copy,nonatomic)NSString *name;

+(id)fenleiWithDict:(NSDictionary *)dict;
-(id)initWithDict:(NSDictionary *)dict;
@end
