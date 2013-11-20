//
//  InfoCell.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-18.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [UIView new];
        
        self.coverBt = [[UIButton alloc] initWithFrame:CGRectMake(50, 10, 300, 50)];
        self.coverBt.backgroundColor = [UIColor redColor];
        [self.coverBt setTitle:@"退出" forState:UIControlStateNormal];
        [self addSubview:self.coverBt];
        [self.coverBt addTarget:self action:@selector(cellSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)cellSelected{
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoCellView:)]) {
        [self.delegate infoCellView:self];
    }
}
@end
