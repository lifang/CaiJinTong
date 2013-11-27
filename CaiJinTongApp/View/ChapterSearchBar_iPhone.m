//
//  ChapterSearchBar_iPhone.m
//  CaiJinTongApp
//
//  Created by david on 13-11-17.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ChapterSearchBar_iPhone.h"
#define SEARCH_MASK_LEFT 40
@implementation ChapterSearchBar_iPhone

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backImageView = [[UIImageView alloc] initWithFrame:(CGRect){}];
        self.backImageView.image = [UIImage imageNamed:@"s.png"];
        [self addSubview:self.backImageView];
        
        self.searchBt = [[UIButton alloc] initWithFrame:(CGRect){}];
        [self.searchBt setBackgroundImage:[[UIImage imageNamed:@"course-courses_03.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [self.searchBt addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.searchBt];
        
        self.searchTextField = [[TextFieldForSearchBar alloc] init];
        self.searchTextField.keyboardType = UIKeyboardTypeDefault;
        self.searchTextField.returnKeyType = UIReturnKeySearch;
        self.searchTextField.textColor = [UIColor grayColor];
        self.searchTextField.placeholder = @"搜索课程";
        [self.searchTextField setTextColor: [UIColor colorWithRed:85.0/255.0 green:113.0/255.0 blue:132.0/255.0 alpha:1.0f]];
        self.searchTextField.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.searchTextField.window makeKeyAndVisible];

        [self addSubview:self.searchTextField];
        self.searchTextField.delegate = self;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backImageView.frame = (CGRect){0,0,self.frame.size.width,self.frame.size.height};
    self.searchBt.frame = (CGRect){CGRectGetMinX(self.backImageView.frame)+6,6,CGRectGetHeight(self.backImageView.frame)-10,CGRectGetHeight(self.backImageView.frame)-10};
    self.searchTextField.frame = (CGRect){CGRectGetMaxX(self.searchBt.frame)+11,8,CGRectGetWidth(self.backImageView.frame) - CGRectGetMaxX(self.searchBt.frame) - 13,CGRectGetHeight(self.backImageView.frame)};

}


-(void)beginSearch{
    [self.searchTextField resignFirstResponder];
    if ([[self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chapterSeachBar_iPhone:beginningSearchString:)]) {
        [self.delegate chapterSeachBar_iPhone:self beginningSearchString:self.searchTextField.text];
    }
}

#pragma mark -- textField Delegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(!textField.window.isKeyWindow){
        [textField.window makeKeyAndVisible];
    }
    return YES;
}

@end
