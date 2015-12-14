//
//  UndercarriageDetailController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/26.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "UndercarriageDetailController.h"
#import "MessageFormat.h"
#import "Mydefine.h"
#import "NSDictionary+GetObjectBykey.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+PriceString.m"

@implementation UndercarriageDetailController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"已下架的商品";
    
    [MessageFormat POST:OffNeighborShop parameters:@{@"NeighborId":self.shopID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSDictionary *data=responseObject[@"data"];
            NSArray *arr=[data getObjectByKey:@"Pics"];
            [self.picImg setImageWithURL:[NSURL URLWithString:arr.firstObject] placeholderImage:[UIImage imageNamed:@"picture_default_LL.jpg"]];
            self.nameLab.text=[data getObjectByKey:@"Name"];
            self.priceLab.text=[NSString priceStringWithPrice:[data getObjectByKey:@"Price"]];
            self.releaseTimeLab.text=[NSString stringWithFormat:@"发布时间：%@",[data getObjectByKey:@"CreateTime"]];
            self.usernameLab.text=[NSString stringWithFormat:@"操作人：%@",[data getObjectByKey:@"OffRole"]];
            self.stateLab.text=[NSString stringWithFormat:@"状态：%@",[data getObjectByKey:@"Status"]];
            self.undercarriageTimeLab.text=[NSString stringWithFormat:@"下架时间：%@",[data getObjectByKey:@"OffTime"]];
            self.descLab.text=[NSString stringWithFormat:@"下架说明：%@",[data getObjectByKey:@"Remark"]];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } incontroller:self view:self.view];
}
@end
