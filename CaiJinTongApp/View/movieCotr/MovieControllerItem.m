//
//  MovieControllerItem.m
//  CaiJinTongApp
//
//  Created by david on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MovieControllerItem.h"
@interface MovieControllerItem()
//@property (weak,nonatomic) IBOutlet UIButton *movieItemCoverBt;
@end

@implementation MovieControllerItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"MovieControllerItem touch Begin");
    self.isSelected = !self.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayBarSelected:)]) {
        [self.delegate moviePlayBarSelected:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"play-M2.png"]];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}
@end
