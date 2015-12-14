//
//  AddaddressController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/1.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

#define REFRESH_ADDRESSLIST @"refreshadresslist"

typedef enum AddressManageType
{
    AddressManageTypeAdd=0,
    AddressManageTypeEdit
}AddressManageType;

@interface AddressDetailInfo : NSObject

@property(copy,nonatomic)NSString *ID;
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *phoneNum;
@property(copy,nonatomic)NSString *postalcode;
@property(copy,nonatomic)NSString *detailaddress;
@property(copy,nonatomic)NSString *province;
@property(copy,nonatomic)NSString *city;
@property(copy,nonatomic)NSString *area;

@end

@interface AddaddressController : UITableViewController

@property(copy,nonatomic)NSString *addressID;
@property(assign,nonatomic)AddressManageType type;
@property(retain,nonatomic)AddressDetailInfo *addressdetail;

@property (weak, nonatomic) IBOutlet UITableViewCell *areacell;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTxt;
@property (weak, nonatomic) IBOutlet UITextField *youbianTxt;

- (IBAction)addAddress:(UIButton *)sender;
@end
