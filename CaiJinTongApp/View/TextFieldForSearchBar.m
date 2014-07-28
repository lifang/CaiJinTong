//
//  TextFieldForSearchBar.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-27.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "TextFieldForSearchBar.h"

@implementation TextFieldForSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawPlaceholderInRect:(CGRect)rect{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    
    [[UIColor colorWithRed:90.0/255.0 green:118.0/255.0 blue:137.0/255.0 alpha:1.0f] setFill];
    
    
    
    [self.placeholder drawInRect:rect withFont:[UIFont boldSystemFontOfSize:15]];
}

@end
