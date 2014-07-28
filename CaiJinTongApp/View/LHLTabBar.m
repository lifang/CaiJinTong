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

-(void)layoutItemsWithIndex:(int)index{
    LHLTabBarItem *temp = self.items[index < 3?0:3];
    if (temp.frame.origin.y == 0) {
        return;
    }
    for (int i = 0; i < self.items.count; i++) {
        LHLTabBarItem *item = self.items[i];
        if (i < 3) {
            if (item.frame.origin.y == 0) {
                item.frame = (CGRect){i%3 * self.frame.size.width / 3,CGRectGetHeight(self.frame),self.frame.size.width / 3,self.frame.size.height};
            }else{
                item.frame = (CGRect){i%3 * self.frame.size.width / 3,0,self.frame.size.width / 3,self.frame.size.height};
            }
        }else{
            if (item.frame.origin.y == 0) {
                item.frame = (CGRect){i%3 * self.frame.size.width / 3,-CGRectGetHeight(self.frame),self.frame.size.width / 3,self.frame.size.height};
            }else{
                item.frame = (CGRect){i%3 * self.frame.size.width / 3,0,self.frame.size.width / 3,self.frame.size.height};
            }
        }
    }
}


//摆放详细按钮
-(void)layoutItems{
    [UIView animateWithDuration:0.5 animations:^{
        for (int i = 0; i < self.items.count; i++) {
            LHLTabBarItem *item = self.items[i];
            if (i < 3) {
                if (item.frame.origin.y == 0) {
                    item.frame = (CGRect){i%3 * self.frame.size.width / 3,CGRectGetHeight(self.frame),self.frame.size.width / 3,self.frame.size.height};
                }else{
                    item.frame = (CGRect){i%3 * self.frame.size.width / 3,0,self.frame.size.width / 3,self.frame.size.height};
                }
            }else{
                if (item.frame.origin.y == 0) {
                    item.frame = (CGRect){i%3 * self.frame.size.width / 3,-CGRectGetHeight(self.frame),self.frame.size.width / 3,self.frame.size.height};
                }else{
                    item.frame = (CGRect){i%3 * self.frame.size.width / 3,0,self.frame.size.width / 3,self.frame.size.height};
                }
            }
        }
    } completion:^(BOOL finished) {
        
    }];
}

//摆放三个按钮
-(void)layoutItems_fake{
    [UIView animateWithDuration:0.5 animations:^{
        for (int i = 0; i < self.items.count; i++) {
            LHLTabBarItem *item = self.items[i];
            if (i < 3) {
                if (item.frame.origin.y == 0) {
                    item.frame = (CGRect){i%3 * self.frame.size.width / 3,CGRectGetHeight(self.frame),self.frame.size.width / 3,self.frame.size.height};
                }else{
                    item.frame = (CGRect){i%3 * self.frame.size.width / 3,0,self.frame.size.width / 3,self.frame.size.height};
                }
            }else{
                if (item.frame.origin.y == 0) {
                    item.frame = (CGRect){i%3 * self.frame.size.width / 3,-CGRectGetHeight(self.frame),self.frame.size.width / 3,self.frame.size.height};
                }else{
                    item.frame = (CGRect){i%3 * self.frame.size.width / 3,0,self.frame.size.width / 3,self.frame.size.height};
                }
            }
        }
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark

#pragma mark property

-(void)setItems:(NSMutableArray *)items{
    _items = items;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    int count = items.count;
    if (count >= 3) {
        count = 3;
    }
    for (int i = 0; i < self.items.count; i++) {
        LHLTabBarItem *item = self.items[i];
        item.tag = i;
        item.frame = (CGRect){i%count * self.frame.size.width / count,i <count?(0):-CGRectGetHeight(self.frame),self.frame.size.width / count,self.frame.size.height};
         [self addSubview:item];
    }
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    for (LHLTabBarItem *item  in self.items) {
        if (item.tag == selectedIndex) {
            item.selected = YES;
        }else{
            item.selected = NO;
        }
    }
}

@end
