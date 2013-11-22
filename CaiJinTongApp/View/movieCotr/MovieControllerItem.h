//
//  MovieControllerItem.h
//  CaiJinTongApp
//
//  Created by david on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MovieControllerItemDelegate;
@interface MovieControllerItem : UIControl
@property (weak,nonatomic) IBOutlet UIImageView *movieItemImageView;
@property (weak,nonatomic) IBOutlet UILabel *movieItemTitleLabel;
@property (weak,nonatomic) id<MovieControllerItemDelegate> delegate;
@property (assign,nonatomic) BOOL isSelected;
@end

@protocol MovieControllerItemDelegate <NSObject>

-(void)moviePlayBarSelected:(MovieControllerItem*)item;

@end