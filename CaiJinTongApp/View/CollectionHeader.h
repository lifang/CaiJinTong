//
//  CollectionHeader.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-6.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionHeader;

@protocol CollectionHeaderDelegate;
@interface CollectionHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *nameItem;
@property (weak, nonatomic) IBOutlet UIButton *defaultItem;
@property (weak, nonatomic) IBOutlet UIButton *progressItem;
@property (nonatomic,assign) id<CollectionHeaderDelegate> delegate;
@end


@protocol CollectionHeaderDelegate <NSObject>
- (void)tappedInToolbar:(CollectionHeader *)toolbar recentButton:(UIButton *)button;
- (void)tappedInToolbar:(CollectionHeader *)toolbar progressButton:(UIButton *)button;
- (void)tappedInToolbar:(CollectionHeader *)toolbar nameButton:(UIButton *)button;
@end