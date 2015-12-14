//
//  FamilyCell.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FamilyCell;

@protocol FamilyCellDelegate <NSObject>

-(void)editMember:(FamilyCell *)cell;
-(void)deleteMember:(FamilyCell *)cell;

@end

@interface FamilyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLab;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *relationshipLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property(retain,nonatomic)id<FamilyCellDelegate> mydelegate;




- (IBAction)deleteMember:(UIButton *)sender;
- (IBAction)editMember:(UIButton *)sender;
@end
