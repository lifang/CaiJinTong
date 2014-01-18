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

//摆放详细按钮
-(void)layoutItems{
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    for(NSUInteger i = 0; i < self.items.count; i ++ ){
        LHLTabBarItem *item = self.items[i];
        if(i < 3){
            item.frame = (CGRect){0,0,self.frame.size.width / 3,self.frame.size.height};
            [self addSubview:item];
            [item setNeedsLayout];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        for(NSUInteger i = 0; i < self.items.count; i ++ ){
            LHLTabBarItem *item = self.items[i];
            if(i < 3){
                item.frame = (CGRect){i * self.frame.size.width / 3,0,self.frame.size.width / 3,self.frame.size.height};
                if(i == 0){
                    item.imageView.alpha = 1.0;
                }
            }
        }
    } completion:^(BOOL finished) {
        
    }];
}

//摆放三个按钮
-(void)layoutItems_fake{
    [UIView animateWithDuration:0.5 animations:^{
        for(NSUInteger i = 0; i < self.items.count; i ++ ){
            LHLTabBarItem *item = self.items[i];
            if(i < 3){
                item.frame = (CGRect){0,0,self.frame.size.width / 3,self.frame.size.height};
                if(i == 0){
                    item.imageView.alpha = 1.0;
                }
            }
        }
    } completion:^(BOOL finished) {
        NSArray *views = [self subviews];
        for(UIView* view in views)
        {
            [view removeFromSuperview];
        }
        [self addSubview:self.fakeItem];
        [self.fakeItem setNeedsLayout];
        self.fakeItem.imageView.alpha = 1.0;
        LHLTabBarItem *item4 = self.items[3];
        item4.frame = (CGRect){self.frame.size.width / 3 ,0,self.frame.size.width / 3,self.frame.size.height};
        [self addSubview:item4];
        [item4 setNeedsLayout];
        LHLTabBarItem *item5 = self.items[4];
        item5.frame = (CGRect){2 * self.frame.size.width / 3,0,self.frame.size.width / 3,self.frame.size.height};
        [self addSubview:item5];
        [item5 setNeedsLayout];
    }];
}
#pragma mark

#pragma mark property
-(LHLTabBarItem *)fakeItem{
    if(!_fakeItem){
        _fakeItem = [[LHLTabBarItem alloc] initWithTitle:@"学习" andImage:[UIImage imageNamed:@"lessons.png"]];
        _fakeItem.frame = (CGRect){0,0,self.frame.size.width / 3,self.frame.size.height};
        _fakeItem.tag = 86;
        _fakeItem.imageView.alpha = 1.0;
    }
    return _fakeItem;
}

-(void) setItems:(NSMutableArray *)items{
    _items = [NSMutableArray arrayWithArray:items];
    [self layoutItems_fake];
    self.selectedIndex = 0;
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex{
    if(selectedIndex == 86){
        return;
    }
    //高亮显示
    if(selectedIndex >2) {
        self.fakeItem.imageView.alpha = 0.5;
    }
    if(self.items.count > 0){
        ((LHLTabBarItem *)self.items[_selectedIndex]).imageView.alpha = 0.5;
        ((LHLTabBarItem *)self.items[selectedIndex]).imageView.alpha = 1.0;
    }
    _selectedIndex = selectedIndex;
}

@end
