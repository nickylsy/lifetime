//
//  MessageFormat.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MessageFormat.h"
#import "AsyncUdpSocket.h"
#import "AppDelegate.h"
#import "BDKNotifyHUD.h"
#import "UIViewController+ActivityHUD.h"

#define TESTSERVER_DOMIN @"http://121.42.41.180:15178/"
//#define REGULARSERVER_DOMIN @"http://box.stang.cn:15178/"
#define REGULARSERVER_DOMIN @"http://123.57.252.38:15178/"
@implementation MessageFormat


+ (BOOL)isEmailAddress:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure incontroller:(UIViewController *)controller view:(UIView *)view
{
    [controller pleaseWaitInView:view];
    [[AFAppDotNetAPIClient sharedClient] POST:URLString.URLEncodedString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [controller endWaiting];
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [controller endWaiting];
        
        [self hintWithMessage:error.localizedDescription inview:view completion:nil];
        
        if (failure) {
            failure(task,error);
        }
    }];
}

+(void)hintWithMessage:(NSString *)message inview:(UIView *)view completion:(void (^)(void))finishblock
{
    BDKNotifyHUD *hud=[BDKNotifyHUD notifyHUDWithImage:nil text:message];
    
    hud.center=CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    [view addSubview:hud];
    [hud presentWithDuration:0.5 speed:0.3 inView:view completion:^{
        if (finishblock) {
            finishblock();
        }
        [hud removeFromSuperview];
    }];
}

+(void)sendMessage:(NSString *)msg socketDelegate:(id<MyXMLParseDelegate>)sockdelegate tag:(long)tag
{
    NSLog(@"发送HTTP消息：%@",msg);
   
    NSString *urlstring=REGULARSERVER_DOMIN.URLEncodedString;
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlstring]];
    [request setHTTPMethod:@"POST"];
    
    //create the body
    NSData *postBody = [msg.URLEncodedString dataUsingEncoding:NSUTF8StringEncoding];
    
//    NSString *length = [NSString stringWithFormat:@"%lu",(unsigned long)postBody.length];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request addValue:@"yishengyue" forHTTPHeaderField:@"UserType"];
    
    //post
    [request setHTTPBody:postBody];

    request.timeoutInterval=10.0;
    
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [(UIViewController *)sockdelegate endWaiting];
        if (connectionError) {
            NSLog(@"%@",connectionError.debugDescription);
            [sockdelegate anythingError];
        } else if (data) {
            NSLog(@"收到HTTP消息：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                   dispatch_async(dispatch_get_main_queue(), ^{
                       NSXMLParser *paser=[[NSXMLParser alloc] initWithData:data];
                       paser.delegate=sockdelegate;
                       [paser parse];
                   });
            
        }
        
    }];
}

+(NSString *)bindToboxwithuserID:(NSString *)userid boxID:(NSString *)boxid
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"bind\"><boxid>%@</boxid><username>%@</username></para></info>",boxid,userid];
}

+(NSString *)airvalueWithboxID:(NSString *)boxid
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> <info><para action=\"request\"><ret>airvalue</ret><id>%@</id></para></info>",boxid];
}

+(NSString *)learnWithboxID:(NSString *)boxid username:(NSString *)username btnID:(NSString *)btnID
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info> <para action=\"learn\"><username>%@</username><boxid>%@</boxid><btnid>%@</btnid></para> </info>",username,boxid,btnID];
}
+(NSString *)controlWithboxID:(NSString *)boxid btnID:(NSString *)btnID
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info> <para action=\"sendir\"><btnid>%@</btnid><boxid>%@</boxid></para> </info>",btnID,boxid];
}

+(NSString *)learnretWithboxID:(NSString *)boxid btnID:(NSString *)btnID
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info> <para action=\"learnret\"><boxid>%@</boxid><btnid>%@</btnid></para> </info>",boxid,btnID];
}

+(NSString *)allboxWithusername:(NSString *)username
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"allbox\"><username>%@</username></para></info>",username];
}

+(NSString *)deletedeviceWithboxID:(NSString *)boxID deviceID:(NSString *)deviceID
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"deldevice\"><boxid>%@</boxid><deviceid>%@</deviceid></para> </info>",boxID,deviceID];
}

+(NSString *)deletebuttonWithboxID:(NSString *)boxID btnID:(NSString *)btnID
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"delbutton\"><boxid>%@</boxid><btnid>%@</btnid></para></info>",boxID,btnID];
}

+(NSString *)debindboxID:(NSString *)boxid username:(NSString *)username
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> <info><para action=\"delbind\"><username>%@</username> <boxid>%@</boxid></para> </info>",username,boxid];
}

+(NSString *)maxbtnIDWithboxID:(NSString *)boxID
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> <info><para action=\"maxid\"><boxid>%@</boxid></para> </info>",boxID];
}

+(NSString *)adddeviceWithboxID:(NSString *)boxID deviceID:(NSString *)deviceID deviceName:(NSString *)deviceName
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> <info><para action=\"adddevice\"><boxid>%@</boxid><deviceid name=\"%@\">%@</deviceid></para></info>",boxID,deviceName,deviceID];
}

+(NSString *)alldeviceWithboxID:(NSString *)boxID
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"alldevice\"><boxid>%@</boxid></para></info>",boxID];
}

+(NSString *)maxdeviceIDWithboxID:(NSString *)boxID deviceType:(NSString *)deviceType
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"maxdeviceid\"><boxid>%@</boxid><devicetype>%@</devicetype></para></info>",boxID,deviceType];
}

+(NSString *)allbuttonWithboxID:(NSString *)boxID deviceID:(NSString *)deviceID
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"allbutton\"><boxid>%@</boxid><deviceid>%@</deviceid></para></info>",boxID,deviceID];
}

+(NSString *)setboxnameWithboxID:(NSString *)boxID boxname:(NSString *)boxname
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"setboxname\"><boxid name=\"%@\">%@</boxid></para></info>",boxname,boxID];
}

+(NSString *)setbuttonnameWithboxID:(NSString *)boxID btnID:(NSString *)btnID btnname:(NSString *)btnname
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"setbtnname\"><boxid>%@</boxid><btnid name=\"%@\">%@</btnid></para></info>",boxID,btnname,btnID];
}

+(NSString *)registerWithusername:(NSString *)username password:(NSString *)psd
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"register\"><name>%@</name><password>%@</password></para></info>",username,psd];
}

+(NSString *)loginWithusername:(NSString *)username password:(NSString *)psd
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><info><para action=\"login\"><name>%@</name><password>%@</password></para></info>",username,psd];
}


@end
