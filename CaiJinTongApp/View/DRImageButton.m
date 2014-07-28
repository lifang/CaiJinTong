//
//  DRImageButton.m
//  CaiJinTongApp
//
//  Created by david on 14-1-9.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRImageButton.h"

@implementation DRImageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)imageButtonClicked:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageButton:withType:)]) {
        [self.delegate imageButton:self withType:self.imageButtonType];
    }
}


-(void)setTitle:(NSString*)title withImage:(UIImage*)image withType:(DRImageButtonType)type{
    self.imageButtonType = type;
    self.titleLabel.text = title;
    self.titleImageView.image = image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
