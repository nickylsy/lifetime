//
//  MessageOfMessageCenter.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/28.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MessageOfMessageCenter : NSObject

@property(copy,nonatomic)NSString *title;
@property(copy,nonatomic)NSString *content;
@property(copy,nonatomic)NSString *date;
@property(copy,nonatomic)NSString *ID;
@property(assign,nonatomic)BOOL selected;
@property(assign,nonatomic)CGFloat cellheight;
@property(assign,nonatomic)BOOL isRead;

+(id)messageWihtDictionary:(NSDictionary *)dict;
-(id)initWihtDictionary:(NSDictionary *)dict;

@end
