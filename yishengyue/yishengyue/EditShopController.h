//
//  EditShopController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/15.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#define REFRESH_SHOPLIST @"refreshmyshoplist"
@interface EditShopController : UIViewController

@property(copy,nonatomic)NSString *shopID;

@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *shopDetailTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *picScrollview;
@property (weak, nonatomic) IBOutlet UITextField *shopTitleTxt;
@property (weak, nonatomic) IBOutlet UITextField *shopPriceTxt;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (IBAction)cancel:(id)sender;
- (IBAction)releaseShop:(id)sender;
@end
