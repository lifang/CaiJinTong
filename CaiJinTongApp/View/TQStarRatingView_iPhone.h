//
//  TQStarRatingView_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQStarRatingView_iPhone;

@protocol StarRatingViewDelegate_iPhone <NSObject>

@optional
-(void)starRatingView:(TQStarRatingView_iPhone *)view score:(float)score;

@end

@interface TQStarRatingView_iPhone : UIView

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;
@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <StarRatingViewDelegate_iPhone> delegate;
@property (nonatomic, readonly,assign) int score;
@end