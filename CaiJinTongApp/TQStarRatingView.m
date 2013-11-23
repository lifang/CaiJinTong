//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"
#define PADDING 30
#define START_HEIGHT 25
@interface TQStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@property (nonatomic, strong) UILabel *scoreLabel;
@end

@implementation TQStarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:5];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        self.scoreLabel = [[UILabel alloc] init];
        self.scoreLabel.backgroundColor = [UIColor clearColor];
        self.scoreLabel.textColor = [UIColor lightGrayColor];
        self.scoreLabel.font = [UIFont systemFontOfSize:20];
        if (self.score <= 0) {
            [self setScore:0];
        }
        [self addSubview:self.scoreLabel];
        
        self.starBackgroundView = [self buidlStarViewWithImageName:@"course-onecourse_03.png"];
        self.starForegroundView = [self buidlStarViewWithImageName:@"x.png"];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak TQStarRatingView * weekSelf = self;
    
    [UIView transitionWithView:self.starForegroundView
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
     {
         [weekSelf changeStarForegroundViewWithPoint:point];
     }
                    completion:^(BOOL finished)
     {
    
     }];
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    float startY = CGRectGetHeight(self.bounds)/2 - START_HEIGHT/2;
    float firstX = frame.size.width/2 - (START_HEIGHT+PADDING)*self.numberOfStar/2;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(firstX + START_HEIGHT*i + PADDING*(i-1), startY,START_HEIGHT,START_HEIGHT);
        [view addSubview:imageView];
        imageView.tag = i+1;
        if (i == self.numberOfStar-1) {
            self.scoreLabel.frame = (CGRect){CGRectGetMaxX(imageView.frame)+PADDING,0,frame.size.width -CGRectGetMaxX(imageView.frame)-PADDING,frame.size.height };
        }
    }
    
    return view;
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    for (UIView *subView in self.starBackgroundView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            if ( CGRectGetMinX(subView.frame) <= p.x) {
                self.starForegroundView.frame = CGRectMake(0, 0, CGRectGetMaxX(subView.frame), self.frame.size.height);
                [self setScore:subView.tag];
                if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
                {
                    [self.delegate starRatingView:self score:self.score];
                }
            }
        }
    }
//    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
//    float score = [str floatValue];
//    p.x = score * self.frame.size.width;
//    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
//    
//    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
//    {
//        [self.delegate starRatingView:self score:score];
//    }
}

-(void)setScore:(int)score{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d分",score];
}
@end
