//
//  FamilyMember.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyMember : NSObject

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *age;
@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,copy)NSString *relationship;
@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,assign)BOOL selected;

+(id)memberWithDict:(NSDictionary *)dict;

-(id)initWithDict:(NSDictionary *)dict;

-(void)updateWithDict:(NSDictionary *)dict;

@end
