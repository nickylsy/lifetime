//
//  AppDelegate.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/20.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "YSYUser.h"
#import "Airbox.h"
#import "JGProgressHUD.h"
#import "MessageOfMessageCenter.h"
#import "AddressInfo.h"
#import "AlipayAccount.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic,retain)YSYUser *user;
@property(nonatomic,retain)NSMutableArray *familymembers;
@property (retain,nonatomic)NSMutableArray                 * boxes;
@property (retain,nonatomic)Airbox                         * currentbox;
@property(retain,nonatomic)JGProgressHUD *activityHUD;
@property(retain,nonatomic)NSMutableArray *messages;
@property(retain,nonatomic)NSMutableArray *addresses;
@property(retain,nonatomic)AddressInfo *defaultaddress;
@property(retain,nonatomic)AlipayAccount *alipayaccount;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)logout;

@end

