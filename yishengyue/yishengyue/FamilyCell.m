//
//  FamilyCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "FamilyCell.h"

@implementation FamilyCell

- (void)awakeFromNib {
    // Initialization code
    self.editBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.deleteBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteMember:(UIButton *)sender {
    [self.mydelegate deleteMember:self];
}

- (IBAction)editMember:(UIButton *)sender {
    [self.mydelegate editMember:self];
}
@end
