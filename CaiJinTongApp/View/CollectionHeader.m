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
	[_delegate tappedInToolbar:self recentButton:button];
}
- (IBAction)progressButtonTapped:(UIButton *)button
{
	[_delegate tappedInToolbar:self progressButton:button];
}
- (IBAction)nameButtonTapped:(UIButton *)button
{
	[_delegate tappedInToolbar:self nameButton:button];
}
@end
