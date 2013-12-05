//
//  LessonListHeaderView_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LessonListHeaderView_iPhoneDelegate;
@interface LessonListHeaderView_iPhone : UITableViewHeaderFooterView
@property (nonatomic,strong) UILabel *lessonTextLabel;
@property (nonatomic,strong) UILabel *lessonDetailLabel;//显示count
@property (nonatomic,strong) NSIndexPath *path;
@property (nonatomic,assign) id<LessonListHeaderView_iPhoneDelegate> delegate;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong) UIImageView *flagImageView;
@end

@protocol LessonListHeaderView_iPhoneDelegate <NSObject>

-(void)lessonHeaderView:(LessonListHeaderView_iPhone*)header selectedAtIndex:(NSIndexPath*)path;

@end