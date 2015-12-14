//
//  CircleMyReleaseDetailController.h
//  yishengyue
//
//  Created by 华为-xtoucher on 15/9/23.
//  Copyright © 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MSG_REFRESH_CIRCLE_MYRELEASE_LIST @"refreshCircleMyreleaseList"

@interface CircleMyReleaseDetailController : UIViewController
@property(nonatomic,copy)NSString *type;
@property(nonatomic,retain)NSDictionary *circleInfo;
@end
