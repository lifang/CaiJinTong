//
//  ChapterSearchBar.m
//  CaiJinTongApp
//
//  Created by david on 13-11-17.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ChapterSearchBar.h"
#define SEARCH_MASK_LEFT 40
@interface ChapterSearchBar()

@property (nonatomic,strong) UIImageView *backImageView;

@end
@implementation ChapterSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backImageView = [[UIImageView alloc] initWithFrame:(CGRect){}];
        self.backImageView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];
        self.backImageView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:231.0/255.0 alpha:1].CGColor;
        self.backImageView.layer.borderWidth =2.0;
        self.backImageView.layer.cornerRadius =15.0;
//        self.backImageView.image = [UIImage imageNamed:@"ss.png"];
//        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.backImageView];
        
        self.searchBt = [[UIButton alloc] initWithFrame:(CGRect){}];
        [self.searchBt setImage:[UIImage imageNamed:@"course-courses_03.png"] forState:UIControlStateNormal];
        [self.searchBt addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchUpInside];
//        self.searchBt.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.searchBt];
        
        self.searchTextField = [[UITextField alloc] init];
        self.searchTextField.frame = CGRectMake(55, 10, 250, 33);
        self.searchTextField.keyboardType = UIKeyboardTypeDefault;
        self.searchTextField.returnKeyType = UIReturnKeySearch;
        self.searchTextField.textColor = [UIColor grayColor];
//        self.searchTextField.backgroundColor = [UIColor redColor];
        [self.searchTextField.window makeKeyAndVisible];
//        self.searchTextField.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.searchTextField];
        self.searchTextField.delegate = self;
        
        self.searchTipLabel = [[UILabel alloc] initWithFrame:(CGRect){}];
//        self.searchTipLabel.backgroundColor = [UIColor blackColor];
//        self.searchTipLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.searchTipLabel];
//        self.searchTipLabel.backgroundColor = [UIColor greenColor];
//        self.searchTextField.backgroundColor = [UIColor redColor];
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backImageView.frame = (CGRect){SEARCH_MASK_LEFT,0,CGRectGetWidth(self.frame)-SEARCH_MASK_LEFT*2,30};
    self.searchBt.frame = (CGRect){CGRectGetMinX(self.backImageView.frame)+2,2,CGRectGetHeight(self.backImageView.frame)-4,CGRectGetHeight(self.backImageView.frame)-4};
    self.searchTextField.frame = (CGRect){CGRectGetMaxX(self.searchBt.frame)+3,1,CGRectGetWidth(self.backImageView.frame) - CGRectGetMaxX(self.searchBt.frame)+25,CGRectGetHeight(self.backImageView.frame)};
    self.searchTipLabel.frame = (CGRect){0,CGRectGetHeight(self.frame) - 30,CGRectGetWidth(self.frame),30};
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)beginSearch{
    [self.searchTextField resignFirstResponder];
    if ([[self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        self.searchTipLabel.text = @"";
        [Utility errorAlert:@"搜索文本不能为空"];
    }
    self.searchTipLabel.text = [NSString stringWithFormat:@"以下是根据内容\"%@\"搜索出的内容",self.searchTextField.text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chapterSeachBar:beginningSearchString:)]) {
        [self.delegate chapterSeachBar:self beginningSearchString:self.searchTextField.text];
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
