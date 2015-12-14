//
//  NSDictionary+GetObjectBykey.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/11.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "NSDictionary+GetObjectBykey.h"

@implementation NSDictionary (GetObjectBykey)

-(id)getObjectByKey:(NSString *)key
{
    return [[self objectForKey:key] isEqual:[NSNull null]]?nil:[self objectForKey:key];
}

@end
