//
//  MessageFormat.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+URLEncoding.h"
#import "AFAppDotNetAPIClient.h"


@protocol MyXMLParseDelegate <NSXMLParserDelegate>

-(void)anythingError;

@end

@interface MessageFormat : NSObject

+ (BOOL)isEmailAddress:(NSString *)email;//验证邮箱格式

+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure incontroller:(UIViewController *)controller view:(UIView *)view;

+(void)hintWithMessage:(NSString *)message inview:(UIView *)view completion:(void(^)(void))finishblock;

+(void)sendMessage:(NSString *)msg socketDelegate:(id<NSXMLParserDelegate>)sockdelegate tag:(long)tag;

//绑定盒子
+(NSString *)bindToboxwithuserID:(NSString *)userid boxID:(NSString *)boxid;

//获取盒子周围的微环境数据
+(NSString *)airvalueWithboxID:(NSString *)boxid;

//学习红外控制
+(NSString *)learnWithboxID:(NSString *)boxid username:(NSString *)username btnID:(NSString *)btnID;

//执行红外控制
+(NSString *)controlWithboxID:(NSString *)boxid btnID:(NSString *)btnID;

//查询学习红外控制的结果
+(NSString *)learnretWithboxID:(NSString *)boxid btnID:(NSString *)btnID;

//获取用户绑定的所有盒子
+(NSString *)allboxWithusername:(NSString *)username;

//删除电器
+(NSString *)deletedeviceWithboxID:(NSString *)boxID deviceID:(NSString *)deviceID;

//删除按钮
+(NSString *)deletebuttonWithboxID:(NSString *)boxID btnID:(NSString *)btnID;

//解绑盒子
+(NSString *)debindboxID:(NSString *)boxid username:(NSString *)username;

//获取后五位最大的btnid
+(NSString *)maxbtnIDWithboxID:(NSString *)boxID;

//添加电器
+(NSString *)adddeviceWithboxID:(NSString *)boxID deviceID:(NSString *)deviceID deviceName:(NSString *)deviceName;

//获取盒子下面所有的电器
+(NSString *)alldeviceWithboxID:(NSString *)boxID;

//获取盒子下面编号最大的电器ID
+(NSString *)maxdeviceIDWithboxID:(NSString *)boxID deviceType:(NSString *)deviceType;

//获取电器下面所有的按钮
+(NSString *)allbuttonWithboxID:(NSString *)boxID deviceID:(NSString *)deviceID;

//设置盒子名字
+(NSString *)setboxnameWithboxID:(NSString *)boxID boxname:(NSString *)boxname;

//设置按钮名字
+(NSString *)setbuttonnameWithboxID:(NSString *)boxID btnID:(NSString *)btnID btnname:(NSString *)btnname;

//注册用户
+(NSString *)registerWithusername:(NSString *)username password:(NSString *)psd;

//登陆
+(NSString *)loginWithusername:(NSString *)username password:(NSString *)psd;
@end
