//
//  LHLTabBar.m
//  CaiJinTongApp
//
//  Created by apple on 14-1-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLTabBar.h"

@implementation LHLTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutItems{
    for(NSUInteger i = 0; i < self.items.count; i ++ ){
        LHLTabBarItem *item = self.items[i];
        item.frame = (CGRect){i * self.frame.size.width / self.items.count,0,self.frame.size.width / self.items.count,self.frame.size.height};
        [self addSubview:item];
        [item setNeedsLayout];
    }
}

-(void) setItems:(NSMutableArray *)items{
    _items = [NSMutableArray arrayWithArray:items];
    [self layoutItems];
}
@end
