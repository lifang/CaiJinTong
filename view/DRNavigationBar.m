//
//  DRNavigationBar.m
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRNavigationBar.h"
#define kPadding 10
#define kflagImageWidth 17
#define kflagImageHeight 20
#define ksearchBarHeight 30
#define ksearchBarWidth 200
#define kbackButtonWidth 80
#define kmargin 5
@interface DRNavigationBar()
@property (nonatomic,strong) UIImageView *flagImageView;
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@end
@implementation DRNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,frame.size}];
        self.backgroundImageView.image = [UIImage imageNamed:@"navi_background.png"];
        self.backgroundImageView.autoresizingMask =UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.backgroundImageView];
        // Initialization code
        float flagimageY = (frame.size.height-kflagImageHeight)/2 - kmargin;
        self.flagImageView = [[UIImageView alloc] initWithFrame:(CGRect){kPadding,flagimageY,kflagImageWidth,kflagImageHeight}];
        self.flagImageView.image = [UIImage imageNamed:@"navi_tag.png"];
        self.flagImageView.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:self.flagImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(self.flagImageView.frame)+kPadding,-kmargin,frame.size.width - kbackButtonWidth- ksearchBarWidth - kflagImageWidth - kPadding*3 - CGRectGetMaxX(self.flagImageView.frame),frame.size.height}];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        float searchY = (frame.size.height - ksearchBarHeight)/2 - kmargin;
        self.searchBar = [[DRSearchBar alloc] initWithFrame:(CGRect){frame.size.width-kPadding-kbackButtonWidth-ksearchBarWidth,searchY,ksearchBarWidth,ksearchBarHeight}];
        self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.searchBar];
        
        self.backImageView = [[UIImageView alloc] initWithFrame:(CGRect){frame.size.width-kPadding-kbackButtonWidth,flagimageY+3,kflagImageWidth,kflagImageHeight-5}];
        self.backImageView.image = [UIImage imageNamed:@"navi_back.png"];
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.backImageView];
        
        self.navigationRightItem = [[UIButton alloc]initWithFrame:(CGRect){frame.size.width-kPadding-kbackButtonWidth,-kmargin,kbackButtonWidth,frame.size.height}];
        self.navigationRightItem.backgroundColor = [UIColor clearColor];
        [self.navigationRightItem setTitle:@"返回" forState:UIControlStateNormal];
        self.navigationRightItem.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.navigationRightItem];
        
        self.autoresizingMask =UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)hiddleBackButton:(BOOL)isHidden{
    [self.backImageView setHidden:isHidden];
    [self.navigationRightItem setHidden:isHidden];
}
//-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView* result = [super hitTest:point withEvent:event];
//    if (result)
//        return result;
//    for (UIView* sub in [self.subviews reverseObjectEnumerator]) {
//        CGPoint pt = [self convertPoint:point toView:sub];
//        result = [sub hitTest:pt withEvent:event];
//        if (result)
//            return result;
//    }
//    return nil;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
