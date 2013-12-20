//
//  CollectionHeader.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-6.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "CollectionHeader.h"


@implementation CollectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

    }
    return self;
}
- (IBAction)recentButtonTapped:(UIButton *)button
{
    [self.defaultItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.progressItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.nameItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	[_delegate tappedInToolbar:self recentButton:button];
}
- (IBAction)progressButtonTapped:(UIButton *)button
{
    [self.defaultItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.progressItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nameItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	[_delegate tappedInToolbar:self progressButton:button];
}
- (IBAction)nameButtonTapped:(UIButton *)button
{
    [self.defaultItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.progressItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.nameItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[_delegate tappedInToolbar:self nameButton:button];
}
@end
