//
//  LHLTabBarItem.m
//  CaiJinTongApp
//
//  Created by apple on 14-1-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLTabBarItem.h"
#define IMAGE_SIZE 26.0
#define FONT_SIZ 14
@implementation LHLTabBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(LHLTabBarItem *) initWithTitle:(NSString *)title andImage:(UIImage *)image{
    self = [super init];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZ]];
    self.titleLabel.text = title;
    
    [self.imageView setBackgroundColor:[UIColor clearColor]];
    self.imageView.image = image;
    self.imageView.alpha = 0.5;
    [self.imageView setUserInteractionEnabled:YES];
    [self setUserInteractionEnabled:YES];
    //单指单击
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(itemClicked:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
    [self addGestureRecognizer:singleFingerOne];
    return self;
}

-(void) layoutSubviews{
    [self.imageView setFrame:(CGRect){(self.frame.size.width - IMAGE_SIZE) / 2,(self.frame.size.height - IMAGE_SIZE) / 3,IMAGE_SIZE,IMAGE_SIZE}];
    [self.titleLabel setFrame:(CGRect){- ((self.frame.size.width - IMAGE_SIZE) / 2),self.imageView.frame.size.height,self.frame.size.width,self.frame.size.height - CGRectGetMaxY(self.imageView.frame)}];
}

#pragma mark --
#pragma mark -- action
-(void)itemClicked:(UITapGestureRecognizer *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(tabBarItemSelected:)]){
        [self.delegate tabBarItemSelected:self];
    }
}

#pragma mark --
#pragma mark -- property
-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        [self.imageView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(void)setSelected:(BOOL)selected{
    self.imageView.alpha = selected ? 1.0 : 0.5;
    _selected = selected;
}

@end
