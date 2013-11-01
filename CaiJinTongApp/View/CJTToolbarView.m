//
//  CJTToolbarView.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CJTToolbarView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CJTToolbarView

#define SHADOW_HEIGHT 4.0f


+ (Class)layerClass
{
	return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
		self.userInteractionEnabled = YES;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
        
		CAGradientLayer *layer = (CAGradientLayer *)self.layer;
		UIColor *liteColor = [UIColor colorWithWhite:0.92f alpha:0.8f];
		UIColor *darkColor = [UIColor colorWithWhite:0.32f alpha:0.8f];
		layer.colors = [NSArray arrayWithObjects:(id)liteColor.CGColor, (id)darkColor.CGColor, nil];
        
		CGRect shadowRect = self.bounds; shadowRect.origin.y += shadowRect.size.height; shadowRect.size.height = SHADOW_HEIGHT;
        
		CJTToolbarShadow *shadowView = [[CJTToolbarShadow alloc] initWithFrame:shadowRect];
        
		[self addSubview:shadowView];
    }
    return self;
}


@end


@implementation CJTToolbarShadow

+ (Class)layerClass
{
	return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.autoresizesSubviews = NO;
		self.userInteractionEnabled = NO;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
        
		CAGradientLayer *layer = (CAGradientLayer *)self.layer;
		UIColor *blackColor = [UIColor colorWithWhite:0.24f alpha:1.0f];
		UIColor *clearColor = [UIColor colorWithWhite:0.24f alpha:0.0f];
		layer.colors = [NSArray arrayWithObjects:(id)blackColor.CGColor, (id)clearColor.CGColor, nil];
	}
    
	return self;
}

@end