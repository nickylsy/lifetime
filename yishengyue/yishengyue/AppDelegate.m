//
//  AppDelegate.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/20.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AppDelegate.h"
#import "REFrostedViewController.h"
#import "MenuViewController.h"
#import "MycontainerController.h"
#import "BMapKit.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "AFAppDotNetAPIClient.h"
#import "UserLoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DES3Util.h"

@interface AppDelegate ()
{
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"needyindaopage"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"needyindaopage"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ShareSDK registerApp:@"9009c695edf8"];
    
    [ShareSDK connectWeChatWithAppId:@"wxe75f537f0c0af26b"
                           appSecret:@"680471b6eb5f2aa9027cae6cde40dd73"
                           wechatCls:[WXApi class]];
    
//    // Create content and menu controllers

    _activityHUD=[JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];

    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"rU0fpnVLuhzYGqbC9iqmGQxL"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autologin"]) {
        
        NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:TEL_KEY];
        NSString *password=[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];
        
        [[AFAppDotNetAPIClient sharedClient] POST:Login.URLEncodedString parameters:@{@"Tel":username,@"PassWord":[DES3Util encrypt:password]} success:^(NSURLSessionDataTask *task, id responseObject) {
      
            NSNumber *statuscode=responseObject[@"code"];
            if (statuscode.intValue==0) {
                AppDelegate *myapp=[UIApplication sharedApplication].delegate;
                myapp.user=[YSYUser userWihtDict:responseObject[@"data"]];
                
                // Create content and menu controllers
                MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
                MycontainerController *container=[[MycontainerController alloc] init];
                // Create frosted view controller
                REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:container menuViewController:menuController];
                frostedViewController.direction = REFrostedViewControllerDirectionLeft;
                // Make it a root controller
                self.window.rootViewController=frostedViewController;
            } else {
                [self setdafaultrootcontroller];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self setdafaultrootcontroller];
            NSLog(@"%@",error.debugDescription);
        }];
    }else{
        [self setdafaultrootcontroller];
    }
    return YES;
}

-(void)setdafaultrootcontroller
{
    self.window.rootViewController=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    NSLog(@"exit");
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xtoucher.yishengyue" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"yishengyue" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"yishengyue.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark -
-(void)logout
{
    self.user=nil;
    self.messages=nil;
    self.boxes=nil;
    self.currentbox=nil;
    self.familymembers=nil;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autologin"];
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Tel"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PassWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self setdafaultrootcontroller];
}
@end
