//
//  LessonListHeaderView.h
//  CaiJinTongApp
//
//  Created by david on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LessonListHeaderViewDelegate;
@interface LessonListHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) UILabel *lessonTextLabel;
@property (nonatomic,strong) UILabel *lessonDetailLabel;//显示count
@property (nonatomic,strong) NSIndexPath *path;
@property (nonatomic,assign) id<LessonListHeaderViewDelegate> delegate;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong) UIImageView *flagImageView;
@end

@protocol LessonListHeaderViewDelegate <NSObject>

-(void)lessonHeaderView:(LessonListHeaderView*)header selectedAtIndex:(NSIndexPath*)path;

@end