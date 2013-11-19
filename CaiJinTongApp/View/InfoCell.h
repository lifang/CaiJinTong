//
//  InfoCell.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-18.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InfoCellDelegate;
@interface InfoCell : UITableViewHeaderFooterView
@property (nonatomic, strong) UIButton *coverBt;
@property (nonatomic, assign) id<InfoCellDelegate> delegate;
@end

@protocol InfoCellDelegate <NSObject>

-(void)infoCellView:(InfoCell*)header ;

@end